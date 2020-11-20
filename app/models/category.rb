class Category < ApplicationRecord
  has_and_belongs_to_many :products, :join_table => :categories_products_joins # added this for relation to work
end
