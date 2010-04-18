config_file = "#{RAILS_ROOT}/config/assets_backup_config.yml"
if FileTest.exists?(config_file)
  S3_CONFIG = YAML.load_file(config_file)
else
  raise "Can't find assets_backup_config.yml"
end