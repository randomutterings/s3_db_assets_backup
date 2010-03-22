require 'rails_generator'
require 'rails_generator/commands'

module S3DbAssetsBackup #:nodoc:
  module Generator #:nodoc:
    module Commands #:nodoc:
      module Create
        def s3_db_assets_backup_config_yaml
          file("backup_config.yml", "config/backup_config.yml")
        end
      end

      module Destroy
        def s3_db_assets_backup_config_yaml
          file("backup_config.yml", "config/backup_config.yml")
        end
      end

      module List
        def s3_db_assets_backup_config_yaml
          file("backup_config.yml", "config/backup_config.yml")
        end
      end

      module Update
        def s3_db_assets_backup_config_yaml
          file("backup_config.yml", "config/backup_config.yml")
        end
      end
    end
  end
end

Rails::Generator::Commands::Create.send   :include,  S3DbAssetsBackup::Generator::Commands::Create
Rails::Generator::Commands::Destroy.send  :include,  S3DbAssetsBackup::Generator::Commands::Destroy
Rails::Generator::Commands::List.send     :include,  S3DbAssetsBackup::Generator::Commands::List
Rails::Generator::Commands::Update.send   :include,  S3DbAssetsBackup::Generator::Commands::Update