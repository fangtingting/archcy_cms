class CreateModelPartials < ActiveRecord::Migration
  def change
    create_table :model_partials do |t|
      t.string :controller,limit: 30
      t.string :action,limit: 30
      t.string :model_class
      t.string :main_layout
      t.string :html_title
      t.string :search_partial
      t.boolean :is_page,default: true
      t.boolean :is_layout,default: true
      t.boolean :is_checkbox,default: false
      t.string :table_header
      t.string :custom_partial
      t.string :js_file
      t.string :css_file
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :model_partials,:controller
    add_index :model_partials,:action
  end
end
