class AssetsBackupGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "backup_config.yml", "config/backup_config.yml"
    end
  end
end