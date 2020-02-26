class CreateWebPages < ActiveRecord::Migration[6.0]
  def change
    create_table :web_pages do |t|
      t.string :uri, null: false
      
      t.timestamps
    end

    add_index :web_pages, :uri, unique: true
  end
end
