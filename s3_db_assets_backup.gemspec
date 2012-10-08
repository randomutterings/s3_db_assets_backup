require 'rubygems/package_task'

PKG_FILES = FileList[  
  '{lib}/**/*', 
  '{app}/**/*',
  '{config}/**/*'
]

Gem::Specification.new do |s|
  s.name = "s3_db_assets_backup"
  s.version = "0.1.4"
  s.summary = "Generates rake tasks for backing up and restoring db and public folder to and from an existing S3 bucket"
  s.description = "Generates rake tasks for backing up and restoring your database and public folder (which should also contain any uploaded assets) to and from an existing bucket in your Amazon S3 account.  The rake tasks compresses and uploads each backup with a time stamp and the config file allows you to set how many of each backup to keep.  This gem is based on (http://www.magnionlabs.com/2009/7/7/db-backups)."
  s.authors = "Chris Barnes"
  s.email = "chris@randomutterings.com"
  s.files = PKG_FILES.to_a
  s.homepage = "http://www.randomutterings.com/projects/s3_db_assets_backup"
  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = ["README.rdoc"]
end