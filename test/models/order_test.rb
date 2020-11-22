require "test_helper"

describe Order do
  let(:new_order) {
    Order.new(status: 'paid', name: "buyer", email: "buyer@email.com", address: "123 Ada Court", credit_card_number: '123456789', cvv: '123', expiration_date: '2/21', total: 20)
  }

  it "can be instantiated" do
    # Assert
    expect(new_order.valid?).must_equal true
  end

  it "will have the required fields" do
    # Arrange
    new_order.save
    order = Order.first

    [:status, :name, :email, :address, :credit_card_number, :cvv, :expiration_date, :total].each do |field|
      # Assert
      expect(order).must_respond_to field
    end
  end

  describe "relationships" do
    before do
      new_order.save
      @merchant = Merchant.create(username: "merchant", email: "merchant@email.com")
      @product_1 = Product.create(name: "plant 1", description: "test 1", price: 5.0, photo_url: "link", stock: 5, merchant_id: @merchant.id)
      @product_2 = Product.create(name: "plant 2", description: "test 2", price: 7.0, photo_url: "link", stock: 4, merchant_id: @merchant.id)

      Orderitem.create(quantity: 2, order_id: new_order.id, product_id: @product_1.id, shipped: false)
      Orderitem.create(quantity: 3, order_id: new_order.id, product_id: @product_2.id, shipped: false)
    end

    it "has many orderitems" do
      # Assert
      expect(new_order.orderitems.count).must_equal 2

      new_order.orderitems.each do |orderitem|
        expect(orderitem).must_be_instance_of Orderitem
      end
    end
  end

  describe "validations" do
    it "must have a name" do
      # Arrange
      new_order.name = nil

      # Assert
      expect(new_order.valid?(:checkout)).must_equal false
      expect(new_order.errors.messages).must_include :name
      expect(new_order.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "must have an email" do
      # Arrange
      new_order.email = nil

      # Assert
      expect(new_order.valid?(:checkout)).must_equal false
      expect(new_order.errors.messages).must_include :email
      expect(new_order.errors.messages[:email]).must_equal ["can't be blank"]
    end

    it "must have an address" do
      # Arrange
      new_order.address = nil

      # Assert
      expect(new_order.valid?(:checkout)).must_equal false
      expect(new_order.errors.messages).must_include :address
      expect(new_order.errors.messages[:address]).must_equal ["can't be blank"]
    end

    it "must include the @ sign in email" do
      new_order.email = "email.com"
      expect(new_order.valid?(:checkout)).must_equal false
      expect(new_order.errors.messages).must_include :email
      expect(new_order.errors.messages[:email]).must_equal ["must include @ in email"]
    end

    it "must have a credit card number" do
      # Arrange
      new_order.credit_card_number = nil

      # Assert
      expect(new_order.valid?(:checkout)).must_equal false
      expect(new_order.errors.messages).must_include :credit_card_number
      expect(new_order.errors.messages[:credit_card_number]).must_equal ["can't be blank"]
    end

    it "must have a cvv" do
      # Arrange
      new_order.cvv = nil

      # Assert
      expect(new_order.valid?(:checkout)).must_equal false
      expect(new_order.errors.messages).must_include :cvv
      expect(new_order.errors.messages[:cvv]).must_equal ["can't be blank"]
    end

    it "must have an expiration date" do
      # Arrange
      new_order.expiration_date = nil

      # Assert
      expect(new_order.valid?(:checkout)).must_equal false
      expect(new_order.errors.messages).must_include :expiration_date
      expect(new_order.errors.messages[:expiration_date]).must_equal ["can't be blank"]
    end

    it "must have a zip code" do
      # Arrange
      new_order.zip_code = nil

      # Assert
      expect(new_order.valid?(:checkout)).must_equal false
      expect(new_order.errors.messages).must_include :zip_code
      expect(new_order.errors.messages[:zip_code]).must_equal ["can't be blank"]
    end

    it "must have a total" do
      # Arrange
      new_order.total = nil

      # Assert
      expect(new_order.valid?(:checkout)).must_equal false
      expect(new_order.errors.messages).must_include :total
      expect(new_order.errors.messages[:total]).must_equal ["can't be blank"]
    end
  end

  describe "custom methods" do
    describe "make_cart" do
      it "creates the shopping cart, which is an instance of order" do
        expect(Order.make_cart).must_be_instance_of Order
      end
    end

    describe "contains_product_sold_by_merchant" do
      before do
        new_order.save
        @merchant_1 = Merchant.create(username: "merchant", email: "merchant@email.com")
        @merchant_2 = Merchant.create(username: "merchant", email: "merchant@email.com")
        @product_1 = Product.create(name: "plant 1", description: "test 1", price: 5.0, photo_url: "link", stock: 5, merchant_id: @merchant_1.id)
        @product_2 = Product.create(name: "plant 2", description: "test 2", price: 7.0, photo_url: "link", stock: 4, merchant_id: @merchant_1.id)

        Orderitem.create(quantity: 2, order_id: new_order.id, product_id: @product_1.id, shipped: false)
        Orderitem.create(quantity: 3, order_id: new_order.id, product_id: @product_2.id, shipped: false)
      end
      it "returns true if the order contains a product sold by a given merchant" do
        # Assert
        expect(new_order.contains_product_sold_by_merchant?(@merchant_1)).must_equal true
      end

      it "returns false if the order does not contain a product sold by a given merchant" do
        # Assert
        expect(new_order.contains_product_sold_by_merchant?(@merchant_2)).must_equal false
      end
    end

    describe "filter_order_items" do
      before do
        new_order.save
        @merchant_1 = Merchant.create(username: "merchant 1", email: "merchant1@email.com")
        @merchant_2 = Merchant.create(username: "merchant 2", email: "merchant2@email.com")
        @product_1 = Product.create(name: "plant 1", description: "test 1", price: 5.0, photo_url: "link", stock: 5, merchant_id: @merchant_1.id)
        @product_2 = Product.create(name: "plant 2", description: "test 2", price: 7.0, photo_url: "link", stock: 4, merchant_id: @merchant_2.id)

        @orderitem_1 = Orderitem.create(quantity: 2, order_id: new_order.id, product_id: @product_1.id, shipped: false)
        @orderitem_2 = Orderitem.create(quantity: 3, order_id: new_order.id, product_id: @product_2.id, shipped: false)
      end

      it "returns order items just for the given merchant" do
        # Assert
        expect(new_order.filter_order_items(@merchant_1)).must_include @orderitem_1
        expect(new_order.filter_order_items(@merchant_2)).must_include @orderitem_2
      end
    end

    describe "checkout" do
      before do
        @order = Order.create(status: "pending", name: "buyer", email: "buyer@email.com", address: "123 Ada Court", credit_card_number: '123456789', cvv: '123', expiration_date: '2/21', total: 20)
        @merchant_1 = Merchant.create(username: "merchant 1", email: "merchant1@email.com")
        @merchant_2 = Merchant.create(username: "merchant 2", email: "merchant2@email.com")
      end

      it "reduces the number of inventory for each product" do
        # Arrange
        @product_1 = Product.create(name: "plant 1", description: "test 1", price: 5.0, photo_url: "link", stock: 5, merchant_id: @merchant_1.id)
        @product_2 = Product.create(name: "plant 2", description: "test 2", price: 7.0, photo_url: "link", stock: 4, merchant_id: @merchant_2.id)

        @orderitem_1 = Orderitem.create(quantity: 2, order_id: @order.id, product_id: @product_1.id, shipped: false)
        @orderitem_2 = Orderitem.create(quantity: 3, order_id: @order.id, product_id: @product_2.id, shipped: false)

        # Act
        @order.checkout

        # Assert
        expect(@product_1.stock).must_equal 3
        expect(@product_2.stock).must_equal 1
      end

      it "changes the order status from pending to paid" do
        @product_1 = Product.create(name: "plant 1", description: "test 1", price: 5.0, photo_url: "link", stock: 5, merchant_id: @merchant_1.id)
        @product_2 = Product.create(name: "plant 2", description: "test 2", price: 7.0, photo_url: "link", stock: 4, merchant_id: @merchant_2.id)

        @orderitem_1 = Orderitem.create(quantity: 2, order_id: @order.id, product_id: @product_1.id, shipped: false)
        @orderitem_2 = Orderitem.create(quantity: 3, order_id: @order.id, product_id: @product_2.id, shipped: false)

        # Act
        @order.checkout

        # Assert
        expect(@order.status).must_equal "paid"
      end

      it "returns true if the order has been successfully checked out" do
        # Arrange
        @product_1 = Product.create(name: "plant 1", description: "test 1", price: 5.0, photo_url: "link", stock: 5, merchant_id: @merchant_1.id)
        @product_2 = Product.create(name: "plant 2", description: "test 2", price: 7.0, photo_url: "link", stock: 4, merchant_id: @merchant_2.id)
        @orderitem_1 = Orderitem.create(quantity: 2, order_id: @order.id, product_id: @product_1.id, shipped: false)
        @orderitem_2 = Orderitem.create(quantity: 3, order_id: @order.id, product_id: @product_2.id, shipped: false)

        # Assert
        expect(@order.checkout).must_equal true
      end

      it "returns false if the order cannot be checked out due to not enough inventory" do
        # Arrange
        @product_1 = Product.create(name: "plant 1", description: "test 1", price: 5.0, photo_url: "link", stock: 5, merchant_id: @merchant_1.id)
        @product_2 = Product.create(name: "plant 2", description: "test 2", price: 7.0, photo_url: "link", stock: 4, merchant_id: @merchant_2.id)
        @orderitem_1 = Orderitem.create(quantity: 6, order_id: @order.id, product_id: @product_1.id, shipped: false)
        @orderitem_2 = Orderitem.create(quantity: 5, order_id: @order.id, product_id: @product_2.id, shipped: false)

        # Assert
        expect(@order.checkout).must_equal false
      end
    end

    describe "can_cancel?" do
      it "returns false if the user tries to cancel an order that has already been cancelled" do
        # Arrange
        cancelled_order = Order.new(status: "cancelled", name: "buyer", email: "buyer@email.com", address: "123 Ada Court", credit_card_number: '123456789', cvv: '123', expiration_date: '2/21', total: 20)

        # Assert
        expect(cancelled_order.can_cancel?).must_equal false
      end

      it "returns false if any of the order items have already been shipped" do
        # Arrange
        shipped_order = Order.new(status: "cancelled", name: "buyer", email: "buyer@email.com", address: "123 Ada Court", credit_card_number: '123456789', cvv: '123', expiration_date: '2/21', total: 20)
        merchant_1 = Merchant.create(username: "merchant 1", email: "merchant1@email.com")
        merchant_2 = Merchant.create(username: "merchant 2", email: "merchant2@email.com")
        product_1 = Product.create(name: "plant 1", description: "test 1", price: 5.0, photo_url: "link", stock: 5, merchant_id: merchant_1.id)
        product_2 = Product.create(name: "plant 2", description: "test 2", price: 7.0, photo_url: "link", stock: 4, merchant_id: merchant_2.id)
        Orderitem.create(quantity: 2, order_id: shipped_order.id, product_id: product_1.id, shipped: true)
        Orderitem.create(quantity: 3, order_id: shipped_order.id, product_id: product_2.id, shipped: false)

        # Assert
        expect(shipped_order.can_cancel?).must_equal false
      end

      it "returns true if the order can be cancelled" do
        # Arrange
        new_order.save
        merchant_1 = Merchant.create(username: "merchant 1", email: "merchant1@email.com")
        merchant_2 = Merchant.create(username: "merchant 2", email: "merchant2@email.com")
        product_1 = Product.create(name: "plant 1", description: "test 1", price: 5.0, photo_url: "link", stock: 5, merchant_id: merchant_1.id)
        product_2 = Product.create(name: "plant 2", description: "test 2", price: 7.0, photo_url: "link", stock: 4, merchant_id: merchant_2.id)
        Orderitem.create(quantity: 2, order_id: new_order.id, product_id: product_1.id, shipped: false)
        Orderitem.create(quantity: 3, order_id: new_order.id, product_id: product_2.id, shipped: false)

        # Assert
        expect(new_order.can_cancel?).must_equal true
      end

    end

    describe "cancel" do
      it "returns false if the order cannot be cancelled" do
        new_order.save


      end

      it "returns false if the status update cannot be saved" do

      end

      it "returns false if the product stock cannot be updated to reflect the cancelled order" do

      end

      it "returns true if the order is cancelled" do

      end

    end

    describe "total" do
      before do
        new_order.save
        @merchant_1 = Merchant.create(username: "merchant 1", email: "merchant1@email.com")
        @merchant_2 = Merchant.create(username: "merchant 2", email: "merchant2@email.com")
        @product_1 = Product.create(name: "plant 1", description: "test 1", price: 5.0, photo_url: "link", stock: 5, merchant_id: @merchant_1.id)
        @product_2 = Product.create(name: "plant 2", description: "test 2", price: 7.0, photo_url: "link", stock: 4, merchant_id: @merchant_2.id)

        @orderitem_1 = Orderitem.create(quantity: 2, order_id: new_order.id, product_id: @product_1.id, shipped: false)
        @orderitem_2 = Orderitem.create(quantity: 3, order_id: new_order.id, product_id: @product_2.id, shipped: false)
      end

      it "calculates the order total correctly" do
        expect(new_order.total).must_equal 31.0
      end
    end
  end
end
