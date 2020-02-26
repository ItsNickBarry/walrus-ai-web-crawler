class WebPage < ApplicationRecord
  validates :uri, presence: true, uniqueness: true

  has_many :parent_relationships, class_name: 'WebPageRelationship', foreign_key: :child_id, dependent: :destroy
  has_many :child_relationships, class_name: 'WebPageRelationship', foreign_key: :parent_id, dependent: :destroy

  has_many :parents, through: :parent_relationships
  has_many :children, through: :child_relationships
end
