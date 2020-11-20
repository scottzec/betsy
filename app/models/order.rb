class Order < ApplicationRecord
  has_many :orderitems
  # has_many :merchants, through: [:orderitems, :products]

  def self.make_cart
    Order.create
  end

  def contains_product_sold_by_merchant?(merchant)
    self.orderitems.each do |orderitem|
      if orderitem.product.merchant == merchant
        return true
      end
    end
    return false
  end

  # retrieve order items just for this merchant
  def filter_order_items(merchant)
    self.orderitems.to_a.select { |orderitem| orderitem.product.merchant == merchant}
  end

  def checkout
    # Purchasing an order makes the following changes:
    # Reduces the number of inventory for each product
    # Changes the order state from "pending" to "paid"
    # Clears the current cart
    Order.transaction do
      # self.status = "paid"
      items = self.orderitems
      items.each do |item|
        if item.product.stock < item.quantity
          return false
        end
        item.product.stock -= item.quantity
        return false unless item.product.save
      end
      return false unless self.save
    end
    self.status = "paid"
    return true
  end

  def can_cancel
    # is this order able to be cancelled
    # none of these items should be shipped
    return false if self.orderitems.to_a.any? { |item| item.shipped }
      # flash[:error] = "Sorry, we cannot cancel your order as items have already shipped"
      # redirect_to root_path

    # self.orderitems.each do |item|
    #   if item.shipped
    #     return false
    #   end
    # end

      items = self.orderitems
      items.each do |item|
        item.product.stock += item.quantity
        return false unless item.product.save
      end
      return false unless self.save
      return true
  end

  def complete
    return self.orderitems.to_a.all? { |item| item.shipped }
  end

  def total
    sum = 0
    self.orderitems.each do |item|
      sum += item.quantity * item.product.price
    end
    return sum
  end
end
