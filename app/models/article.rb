class Article < ActiveRecord::Base
  def self.ui_config
    YAML.load(File.read(Rails.root.to_s + "/config/ymls/ui.yml"))
  end

  def self.list_fields
    ui_config['Article']['table']
  end

end