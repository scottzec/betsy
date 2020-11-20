class Merchant < ApplicationRecord
  has_many :products
  has_many :orderitems, through: :products

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  #
  # def self.build_from_github(auth_hash)
  #   merchant = Merchant.new
  #   merchant.uid = auth_hash[:uid]
  #   merchant.provider = "github"
  #   # merchant can change name later
  #   merchant.username = auth_hash["info"]["name"]
  #   merchant.email = auth_hash["info"]["email"]
  #
  #   return merchant
  # end
  #
  # # total revenue based on completed orders
  # def total_revenue
  #   @orderitems = self.orderitems
  #   return 0 if @orderitems.empty?
  #
  #   total = 0
  #   @orderitems.each do |orderitem|
  #     order = Order.find_by(id: orderitem.order_id)
  #     product = Product.find_by(id: orderitem.product_id)
  #     if order.status.downcase == 'completed'
  #       total += orderitem.quantity * price
  #     end
  #   end
  #
  #   return total
  # end
  #
  # def all_orders
  #   @orderitems = self.orderitems
  #   return nil if @orderitems.empty?
  #   allorders = Hash.new
  #   @orderitems.each do |orderitem|
  #     if allorders.has_key?(orderitem.order_id)
  #       allorders[order_id] << orderitem
  #     else
  #       allorders[order_id] = [orderitem]
  #     end
  #   end
  #
  #   return allorders
  # end

end
