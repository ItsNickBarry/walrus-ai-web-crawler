class WebPage < ApplicationRecord
  validates :title, presence: true
  validates :uri, presence: true, uniqueness: true

  has_many :parent_relationships, class_name: 'WebPageRelationship', foreign_key: :child_id, dependent: :destroy
  has_many :child_relationships, class_name: 'WebPageRelationship', foreign_key: :parent_id, dependent: :destroy

  has_many :parents, through: :parent_relationships
  has_many :children, through: :child_relationships

  def descendents level = 1
    WebPage.find_by_sql((<<-SQL).chomp)
      WITH RECURSIVE graph (parent_id, child_id, level)
      AS (
        SELECT parent_id, child_id, 1
        FROM web_page_relationships
        WHERE parent_id = #{ id }

        UNION ALL

        SELECT rel.parent_id, rel.child_id, g.level + 1
        FROM web_page_relationships rel, graph g
        WHERE rel.parent_id = g.child_id AND level < #{ level }
      )
      SELECT web_pages.*, MIN(level) AS level
      FROM web_pages
      JOIN graph
        ON web_pages.id = graph.child_id
      WHERE id != #{ id }
      GROUP BY id;
    SQL
  end
end
