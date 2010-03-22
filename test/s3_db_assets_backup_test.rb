require File.dirname(__FILE__) + '/test_helper.rb'
require 'rails_generator'
require 'rails_generator/scripts/generate'

class S3DbAssetsBackupTest < Test::Unit::TestCase

  def setup
    FileUtils.mkdir_p(fake_rails_root)
    FileUtils.mkdir_p(config_dir)
    @original_root_files = root_file_list
    @original_config_files = config_file_list
    Rails::Generator::Scripts::Generate.new.run(["assets_backup"], :destination => fake_rails_root)
  end

  def teardown
    FileUtils.rm_r(fake_rails_root)
  end

  def test_generates_config_yaml_file
    new_file = (config_file_list - @original_config_files).first
    assert_equal "backup_config.yml", File.basename(new_file)
  end
  
  private

    def fake_rails_root
      File.join(File.dirname(__FILE__), 'rails_root')
    end
    
    def config_dir
      File.join(File.dirname(__FILE__), 'rails_root/config')
    end

    def root_file_list
      Dir.glob(File.join(fake_rails_root, "*"))
    end
    
    def config_file_list
      Dir.glob(File.join(config_dir, "*"))
    end

end