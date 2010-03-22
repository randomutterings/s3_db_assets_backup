class AssetsBackupGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "assets_backup_config.yml", "config/assets_backup_config.yml"
      m.file "load_assets_backup_config.rb", "config/initializers/load_assets_backup_config.rb"
      m.file "assets_backup.rake", "lib/tasks/assets_backup.rake"
      m.file "db_backup.rake", "lib/tasks/db_backup.rake"
    end
  end
end