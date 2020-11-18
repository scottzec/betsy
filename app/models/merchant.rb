class Merchant < ApplicationRecord
  has_many :products
  has_many :orderitems, through: :products
end
