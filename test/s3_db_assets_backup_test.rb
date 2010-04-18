require File.dirname(__FILE__) + '/test_helper.rb'
require 'rails_generator'
require 'rails_generator/scripts/generate'

class S3DbAssetsBackupTest < Test::Unit::TestCase

  def setup
    # creates all dirs down to initializers and tasks
    FileUtils.mkdir_p(initializers_dir)
    FileUtils.mkdir_p(tasks_dir)
    Rails::Generator::Scripts::Generate.new.run(["s3_backup"], :destination => fake_rails_root)
  end

  def teardown
    FileUtils.rm_r(fake_rails_root)
  end

  def test_generates_backup_config_yaml_file
    assert_generated_file("config/s3_backup_config.yml")
  end
  
  def test_generates_backup_config_initializer
    assert_generated_file("config/initializers/load_s3_backup_config.rb")
  end
  
  def test_generates_assets_backup_rake_task
    assert_generated_file("lib/tasks/assets_backup.rake")
  end
  
  def test_generates_db_backup_rake_task
    assert_generated_file("lib/tasks/db_backup.rake")
  end
  
  private

    def fake_rails_root
      File.join(File.dirname(__FILE__), 'rails_root')
    end
    
    def config_dir
      File.join(File.dirname(__FILE__), 'rails_root/config')
    end
    
    def initializers_dir
      File.join(File.dirname(__FILE__), 'rails_root/config/initializers')
    end
    
    def tasks_dir
      File.join(File.dirname(__FILE__), 'rails_root/lib/tasks')
    end
    
    # Asserts that the given file was generated.
    # The contents of the file is passed to a block.
    def assert_generated_file(path)
      assert_file_exists(path)
      File.open("#{fake_rails_root}/#{path}") do |f|
        yield f.read if block_given?
      end
    end

    # asserts that the given file exists
    def assert_file_exists(path)
      assert File.exist?("#{fake_rails_root}/#{path}"),
        "The file '#{fake_rails_root}/#{path}' should exist"
    end

end