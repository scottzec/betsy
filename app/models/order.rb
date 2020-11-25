class Order < ApplicationRecord
  has_many :orderitems
  validates :status, :name, :email, :address, :credit_card_number, :cvv, :expiration_date, :zip_code, presence: true, on: :checkout_context
  validates :email, format: {with: /@/, message: "must include @ in email"}, on: :checkout_context

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

  # Retrieve order items just for this merchant
  def filter_order_items(merchant)
    self.orderitems.to_a.select { |orderitem| orderitem.product.merchant == merchant}
  end

  def checkout
    # Purchasing an order makes the following changes:
    # Reduces the number of inventory for each product
    # Changes the order state from "pending" to "paid"
    # Clears the current cart
    Order.transaction do
      items = self.orderitems
      items.each do |item|
        if item.product.stock < item.quantity
          raise ActiveRecord::RecordInvalid
          # return false
        end
        item.product.stock -= item.quantity
        item.product.save!
      end
      self.save!
    end
      self.status = "paid"
      return self.save(context: :checkout_context)

    rescue ActiveRecord::RecordInvalid
      errors.add(:base, :checkout_error, message: "Something went wrong. We couldn't checkout your order.")

      return false
  end

  def can_cancel?
    return false if self.status == "cancelled"
    return false if self.orderitems.to_a.any? { |item| item.shipped? } # maybe separate these two
    return true
  end

  def cancel
    Order.transaction do
      raise ActiveRecord::RecordInvalid unless can_cancel?
      self.update!(status: "cancelled")
      items = self.orderitems
      items.each do |item|
        item.product.stock += item.quantity
        item.product.save!
      end
    end

    return true

    rescue ActiveRecord::RecordInvalid
      errors.add(:base, :cancel_error, message: "Something went wrong. We couldn't cancel your order.")

      return false
  end

  def total
    sum = 0
    self.orderitems.each do |item|
      sum += item.quantity * item.product.price
    end
    return sum
  end
end