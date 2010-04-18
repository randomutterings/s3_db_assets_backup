require 'rake/gempackagetask'

PKG_FILES = FileList[
  '[a-zA-Z]*',
  'generators/**/*',
  'lib/**/*',
  'test/**/*'
]

spec = Gem::Specification.new do |s|
  s.name = "s3_db_assets_backup"
  s.version = "0.0.6"
  s.author = "Chris Barnes"
  s.email = "randomutterings@gmail.com"
  s.homepage = "http://www.randomutterings.com/projects/s3_db_assets_backup"
  s.platform = Gem::Platform::RUBY
  s.summary = "Generates rake tasks for backing up and restoring db and public folder to and from an existing S3 bucket"
  s.description = "Generates rake tasks for backing up and restoring your database and public folder (which should also contain any uploaded assets) to and from an existing bucket in your Amazon S3 account.  The rake tasks compresses and uploads each backup with a time stamp and the config file allows you to set how many of each backup to keep.  This gem is based on (http://www.magnionlabs.com/2009/7/7/db-backups)."
  s.files = PKG_FILES.to_a
  s.extra_rdoc_files = ["README.rdoc"]
end

desc 'Turn this plugin into a gem.'
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end