require 'rails/generators'

class S3BackupGenerator < Rails::Generators::Base
  def self.source_root
    @source_root ||= File.join(File.dirname(__FILE__), 'templates')
  end
  
  def generate_layout  
    copy_file "s3_backup_config.yml", "config/s3_backup_config.yml"  
  end
end