require 'rake'
require 'rake/testtask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the s3_db_assets_backup plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end