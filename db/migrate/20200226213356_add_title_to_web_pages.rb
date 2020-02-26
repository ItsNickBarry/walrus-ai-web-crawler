class AddTitleToWebPages < ActiveRecord::Migration[6.0]
  def change
    add_column :web_pages, :title, :string, null: false
  end
end
