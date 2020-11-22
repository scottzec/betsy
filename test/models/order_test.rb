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

  describe "custom methods" do
    describe "make_cart" do

    end

    describe "contains_product_sold_by_merchant" do

    end

    describe "filter_order_items" do

    end

    describe "checkout" do

    end

    describe "can_cancel?" do

    end

    describe "cancel" do

    end

    describe "total" do

    end
  end
end
