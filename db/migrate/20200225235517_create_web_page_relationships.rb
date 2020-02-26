class CreateWebPageRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :web_page_relationships do |t|
      t.integer :parent_id, null: false
      t.integer :child_id, null: false
    end

    add_index :web_page_relationships, [:parent_id, :child_id], unique: true
  end
end
