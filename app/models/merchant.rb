class Merchant < ApplicationRecord
  has_many :products
  has_many :orderitems, through: :products

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"

    # merchant can change name later
    merchant.username = auth_hash[:info][:name]
    if merchant.username.nil?
      merchant.username = auth_hash[:info][:nickname]
      merchant.provider_name = auth_hash[:info][:nickname]
    else
      merchant.provider_name = auth_hash[:info][:name]
    end

    merchant.email = auth_hash[:info][:email]
    merchant.provider_email = auth_hash[:info][:email]

    return merchant
  end


  # total revenue based on completed orders
  # all unique orders and order items associated with merchant, can be sorted by status
  #
  # @params status (string), default nil for all orderitems
  # @output float represent revenue from all order items (of certain category if selected)
  # @post ... should not change any objects or fields involved?
  # invalid status input or having no assoc. orderitems will return 0.
  def total_revenue(status: nil)
    @orderitems = self.orderitems
    return 0 if @orderitems.empty?

    total = 0
    @orderitems.each do |orderitem|
      order = Order.find_by(id: orderitem.order_id)
      product = Product.find_by(id: orderitem.product_id)
      # if no status input, will total everything.
      # if status input, will match by status
      if (status.nil? || order.status.nil?) || order.status.downcase == status
        total += orderitem.quantity * product.price
      end
    end

    return total
  end

  # all unique orders and order items associated with merchant, can be sorted by status
  #
  # @params status (string), default nil for all orders
  # @output hash where Order => [OrderItems]
  # @post ... should not change any objects or fields involved?
  # invalid status input or no orderitems will return an empty hash.
  def get_orders(status: nil)
    orderitems = self.orderitems
    return {} if orderitems.empty?

    allorders = Hash.new
    orderitems.each do |orderitem|
      order = Order.find_by_id(orderitem.order_id)
      # if no status input, will collect everything.
      # if status input, will match by status
      # would be nice if postgresql can hash
      if (status.nil? || order.status.nil?) || order.status.downcase == status
        if allorders.has_key?(order)
          allorders[order] << orderitem
        else
          allorders[order] = [orderitem]
        end
      end
    end

    return allorders
  end

end
