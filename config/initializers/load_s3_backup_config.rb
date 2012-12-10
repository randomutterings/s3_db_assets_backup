config_file = "#{Rails.root.to_s}/config/s3_backup_config.yml"
if FileTest.exists?(config_file)
  S3_CONFIG = YAML.load_file(config_file)[Rails.env].symbolize_keys
  EMAIL_CONFIG = YAML.load_file(config_file)["email_config"].symbolize_keys
else
  puts "WARNING: Can't find s3_backup_config.yml"
end