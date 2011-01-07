require "s3_db_assets_backup"
require "rails"

module S3DbAssetsBackup
  class Engine < Rails::Engine
    
    rake_tasks do
      load "s3_db_assets_backup/railties/assets_backup.rake"
      load "s3_db_assets_backup/railties/db_backup.rake"
    end
  end
end