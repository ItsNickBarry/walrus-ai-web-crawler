class WebPageRelationship < ApplicationRecord
  validates :child, uniqueness: { scope: :parent }

  belongs_to :parent, class_name: 'WebPage'
  belongs_to :child, class_name: 'WebPage'
end
