require 'find'
require 'fileutils'
require 'aws/s3'
require 'pony'

namespace :db do
  desc "Backup the database to a file. Options: RAILS_ENV=production" 
  task :backup => [:environment] do
    # Establish connection to Amazon S3 and fetch the bucket name from the config
    AWS::S3::Base.establish_connection!(:access_key_id => S3_CONFIG[:access_key_id], :secret_access_key => S3_CONFIG[:secret_access_key])
    BUCKET = S3_CONFIG[:bucket]

    # Build the backup directory and filename
    datestamp = Time.now.strftime("%Y-%m-%d-%H-%M-%S")
    base_path = ENV["RAILS_ROOT"] || "." 
    file_name = "#{Rails.env}_dump-#{datestamp}.sql.gz" 
    backup_file = File.join(base_path, "tmp", file_name)

    # Load database configuration and dump the sql database to the backup file
    db_config = ActiveRecord::Base.configurations[Rails.env]
    sh "mysqldump -u #{db_config['username']} -p#{db_config['password']} --default-character-set=latin1 -N -Q --add-drop-table #{db_config['database']} | gzip -c > #{backup_file}" 
    
    # Upload the backup file to Amazon and remove the file from the local filesystem
    AWS::S3::S3Object.store(file_name, open(backup_file), BUCKET)
    puts "Created backup: #{file_name}" 
    FileUtils.rm_rf(backup_file)

    # Check the bucket for the number of backups and remove the oldest backups if
    # it is over the number of backups sets configured
    bucket = AWS::S3::Bucket.find(BUCKET)
    all_backups = bucket.objects.select { |f| f.key.match(/dump/) }.sort { |a,b| a.key <=> b.key }.reverse
    max_backups = S3_CONFIG[:database_backups_to_keep].to_i || 28
    unwanted_backups = all_backups[max_backups..-1] || []
    for unwanted_backup in unwanted_backups
      unwanted_backup.delete
      puts "deleted #{unwanted_backup.key}" 
    end
    puts "Deleted #{unwanted_backups.length} backups, #{all_backups.length - unwanted_backups.length} backups available" 
  end
end

namespace :db do
  desc "Restore the database from an available backup. Options: RAILS_ENV=production" 
  task :restore => [:environment] do
    base_path = ENV["RAILS_ROOT"] || "." 
    db_config = ActiveRecord::Base.configurations[Rails.env]
    AWS::S3::Base.establish_connection!(:access_key_id => S3_CONFIG[:access_key_id], :secret_access_key => S3_CONFIG[:secret_access_key])
    bucket_name = S3_CONFIG[:bucket]
    backups = AWS::S3::Bucket.objects(bucket_name).select { |f| f.key.match(/dump/) }
    if backups.size == 0
      puts "no backups available, check your settings in config/s3_backup_config.yml"
    else
      puts "#{backups.size} backups are available..."
      counter = 0
      backups.each do |backup|
        puts "[#{counter}] #{backup.key}"
        counter += 1
      end
      if backups.size == 1
        puts "Which backup should we restore? [0]"
      else
        puts "Which backup should we restore? [0-#{backups.size - 1}]"
      end
      STDOUT.flush()
      selected = STDIN.gets.chomp.to_i
      if backups.at(selected).nil?
        puts "Backup not found, aborting"
      else
        file_name = backups.at(selected).key
        backup_file = File.join(base_path, "tmp", file_name)
        puts "downloading backup..."
        open(backup_file, 'wb') do |file|
          AWS::S3::S3Object.stream(file_name, bucket_name) do |chunk|
            file.write chunk
          end
        end
        puts "download complete, restoring to #{Rails.env} database"
        sh "gzip -dc #{backup_file} | mysql -u #{db_config['username']} -p#{db_config['password']} #{db_config['database']} --default-character-set=latin1 -N"
        puts "cleaning up..."
        FileUtils.rm_rf(backup_file)
        puts "Finished"
      end
    end
  end
end

namespace :db do
  namespace :backup do
    desc "Email a report of current backups."
    task :status => [:environment] do
      AWS::S3::Base.establish_connection!(:access_key_id => S3_CONFIG[:access_key_id], :secret_access_key => S3_CONFIG[:secret_access_key])
      BUCKET = S3_CONFIG[:bucket]
      bucket = AWS::S3::Bucket.find(BUCKET)
      all_backups = bucket.objects.select { |f| f.key.match(/dump/) }.sort { |a,b| a.key <=> b.key }.reverse

      message = "Archive contains the following backups:\n\n"
      all_backups.each { |f| message << f.key + "\n" }
      email = EMAIL_CONFIG

      Pony.mail(  
        :to => email[:to], 
        :via => email[:via], 
        :subject => email[:subject],
        :body => message,

        :via_options => {
          :address => email[:address],
          :port => email[:port],
          :enable_starttls_auto => email[:enable_starttls_auto],
          :user_name => email[:user_name],
          :password => email[:password],
          :authentication => email[:authentication],
          :domain => email[:domain]
        }
      )
    end
  end
end
