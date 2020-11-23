class Orderitem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  has_one :merchant, through: :product # had to add this to link orderitems to merchant, sorry!

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
