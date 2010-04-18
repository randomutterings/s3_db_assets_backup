class S3BackupGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "s3_backup_config.yml", "config/s3_backup_config.yml"
      m.file "load_s3_backup_config.rb", "config/initializers/load_s3_backup_config.rb"
      m.file "assets_backup.rake", "lib/tasks/assets_backup.rake"
      m.file "db_backup.rake", "lib/tasks/db_backup.rake"
    end
  end
end