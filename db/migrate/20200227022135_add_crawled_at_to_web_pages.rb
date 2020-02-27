class AddCrawledAtToWebPages < ActiveRecord::Migration[6.0]
  def change
    add_column :web_pages, :crawled_at, :datetime
  end
end
