require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the s3_db_assets_backup plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

PKG_FILES = FileList[
  '[a-zA-Z]*',
  'generators/**/*',
  'test/**/*'
]

spec = Gem::Specification.new do |s|
  s.name = "s3_db_assets_backup"
  s.version = "0.0.3"
  s.author = "Chris Barnes"
  s.email = "randomutterings@gmail.com"
  s.homepage = "http://www.randomutterings.com/projects/s3_db_assets_backup"
  s.platform = Gem::Platform::RUBY
  s.summary = "Generates rake tasks for backing up db and public folder to S3 bucket"
  s.files = PKG_FILES.to_a
  s.has_rdoc = false
  s.extra_rdoc_files = ["README.rdoc"]
end

desc 'Turn this plugin into a gem.'
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end