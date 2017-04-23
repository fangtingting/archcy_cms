class ModelPartial < ActiveRecord::Base
  mount_uploader :js_file, AssetUploader
  mount_uploader :css_file, AssetUploader
  MAINLAYOUT = [["index","index"],["form","form"]]
end