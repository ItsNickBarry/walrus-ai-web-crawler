require 'open-uri'

class WebPage < ApplicationRecord
  before_validation :ensure_title

  validates :title, presence: true
  validates :uri, presence: true, uniqueness: true, format: URI::regexp(%w[http https])

  has_many :parent_relationships, class_name: 'WebPageRelationship', foreign_key: :child_id, dependent: :destroy
  has_many :child_relationships, class_name: 'WebPageRelationship', foreign_key: :parent_id, dependent: :destroy

  has_many :parents, through: :parent_relationships
  has_many :children, through: :child_relationships

  def uri_object
    URI.parse(self.uri)
  end

  def document
    @document ||= Nokogiri::HTML.parse(open(self.uri))
  end

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

  def crawl level = 1, cache_expire = 1.second.ago
    return if level < 1

    unless updated_at >= cache_expire
      child_relationships.destroy_all
    end

    document.css('a').each do |a|
      if a.attributes['href']
        child_uri = uri_object.merge(URI.parse(a.attributes['href'].value))
        child = WebPage.find_or_initialize_by(uri: child_uri.to_s)

        if child.valid?
          unless child.persisted? && child.updated_at >= cache_expire
            child.save!
            child.crawl(level - 1, cache_expire)
          end

          child_relationships.find_or_create_by child: child
        end
      end
    end
  end

  private

    def ensure_title
      self.title ||= document.title
    rescue
      self.title = nil
    end
end
