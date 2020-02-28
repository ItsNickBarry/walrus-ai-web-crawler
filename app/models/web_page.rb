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
    @document ||= Nokogiri::HTML.parse(open(uri_object.to_s))
  end

  def descendents depth = 1, cache_expire = 1.second.ago, limit = WebPage.count, offset = 0
    WebPage.find_by_sql((<<-SQL).chomp)
      WITH RECURSIVE graph (parent_id, child_id, depth)
      AS (
        SELECT parent_id, child_id, 1
        FROM web_page_relationships
        JOIN web_pages
          ON parent_id = web_pages.id
        WHERE parent_id = #{ id }
          AND web_pages.crawled_at > '#{ cache_expire }'

        UNION ALL

        SELECT rel.parent_id, rel.child_id, g.depth + 1
        FROM web_page_relationships rel, graph g
        WHERE rel.parent_id = g.child_id AND depth < #{ depth }
      )
      SELECT web_pages.*, MIN(depth) AS depth
      FROM web_pages
      JOIN graph
        ON web_pages.id = graph.child_id
      WHERE id != #{ id }
      GROUP BY id
      LIMIT #{ limit }
      OFFSET #{ offset };
    SQL
  end

  def crawl depth = 1, cache_expire = 1.second.ago
    return [self] if depth < 1

    if self.crawled_at && self.crawled_at > cache_expire
      matches = self.descendents depth, cache_expire
      matches.map! { |child| child.depth == depth ? child : child.crawl(depth - page.depth) }
      matches.flatten << self
    else
      self.child_relationships.destroy_all

      matches = self.document.css('a').select { |a| a.attributes['href'] }.map do |a|
        child_uri = uri_object.merge(URI.parse(a.attributes['href'].value))
        child = WebPage.find_or_initialize_by(uri: child_uri.to_s)

        if child.save
          child_relationships.find_or_create_by child: child
          child.crawl(depth - 1, cache_expire)
        end
      end

      self.update crawled_at: Time.now
      # this would be better achieved with filter_map in Ruby 2.7
      matches.flatten.compact << self
    end
  end

  private

    def ensure_title
      self.title ||= document.title
    rescue
      self.title = nil
    end
end
