class Product < ApplicationRecord
  has_and_belongs_to_many :categories, :join_table => :categories_products_joins # added this for relation to work
  has_many :orderitems
  # needed these to complete the relation, apparently
  has_many :reviews
  belongs_to :merchant

  validates :name, presence: true

  validates :description, presence: true

  validates :price, numericality: { greater_than_or_equal_to: 0 }

  validates :photo_url, presence: true

  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }


  # Custom Method: Optional. Retire a product from being sold, which hides it from browsing
end


