class ModelPartial < ActiveRecord::Base
  MAINLAYOUT = [["index","index"],["form","form"]]
  # mount_uploader :js_file, AssetUploader

  def table_columns
    columns = []
    columns << "<input type='checkbox' autocomplete='off' name='checkall' id='checkall' onclick='toggle(this)' />选本页".html_safe if self.is_checkbox
    columns += self.table_header.split('|')
    return columns
  end
end