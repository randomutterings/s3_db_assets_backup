require 'find'
require 'fileutils'
require 'aws/s3'

namespace :assets do
  desc "Backup everything in the public folder." 
  task :backup => [:environment] do

    # establish a connection and create the s3 bucket
    s3 = AWS::S3.new
    bucket = s3.buckets.create(S3_CONFIG[:bucket])

    # Build the backup directory and filename
    datestamp = Time.now.strftime("%Y-%m-%d-%H-%M-%S")
    base_path = ENV["RAILS_ROOT"] || "." 
    file_name = "#{Rails.env}_assets-#{datestamp}.sql.gz" 
    backup_file = File.join(base_path, "tmp", file_name)
    
    sh "tar -cvzpf #{backup_file} public"
    
    # Upload the backup file to Amazon and remove the file from the local filesystem
    basename = File.basename(file_name)
    object = bucket.objects[basename]
    object.write(:file => backup_file)

    puts "Uploaded #{file_name} to:"
    puts object.public_url

    FileUtils.rm_rf(backup_file)

    all_backups = bucket.objects.select { |f| f.key.match(/assets/) }.sort { |a,b| a.key <=> b.key }.reverse
    max_backups = S3_CONFIG[:assets_backups_to_keep].to_i || 28
    unwanted_backups = all_backups[max_backups..-1] || []
    for unwanted_backup in unwanted_backups
      unwanted_backup.delete
      puts "deleted #{unwanted_backup.key}" 
    end
    puts "Deleted #{unwanted_backups.length} backups, #{all_backups.length - unwanted_backups.length} backups available" 
  end
end

namespace :assets do
  desc "Restore the public folder from an available backup." 
  task :restore => [:environment] do
    base_path = ENV["RAILS_ROOT"] || "." 
    
    # establish a connection and find the s3 bucket
    s3 = AWS::S3.new
    bucket = s3.buckets[S3_CONFIG[:bucket]]

    backups = bucket.objects.select { |f| f.key.match(/assets/) }
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
        backup = backups.at(selected)
        backup_file = File.join(base_path, "tmp", backup.key)
        destination = File.join(base_path, "public")
        puts "downloading backup..."
        open(backup_file, 'wb') do |file|
          backup.read do |chunk|
            file.write chunk
          end
        end
        FileUtils.remove_dir(destination)
        sh "tar zxfv #{backup_file}"
        puts "cleaning up..."
        FileUtils.rm_rf(backup_file)
        puts "Finished"
      end
    end
  end
end