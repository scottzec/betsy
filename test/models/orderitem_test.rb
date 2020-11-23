require "test_helper"

describe Orderitem do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end

  let (:merchant) {
    Merchant.create(username: "Fake Name",
                    email: "fake@name.com")
  }

  let (:order) {
    Order.create(status: "paid", name: "test buyer", email: "test@email.com", address: "123 test st. south", credit_card_number: "1234 5678 9123 4567", cvv: "123", expiration_date: "01/02", zip_code: "12345")
  }

  let (:product) {
    Product.create(name: "Product1", description: "a plant we found", price: 12.35, photo_url: "no url", stock: 10, merchant_id: merchant.id)
  }

  let (:orderitem) {
    Orderitem.create(quantity: 2,
                     order: order,
                     product: product)
  }
  describe "instantiation" do
    it "can be instantiated" do
      expect(orderitem.valid?).must_equal true
    end

    it "will have the required fields" do
      orderitem.save
      new_oi = Orderitem.last
      [:quantity, :order_id, :product_id].each do |field|
        expect(new_oi).must_respond_to field
      end
    end
  end

  describe "relationships" do
    it "belongs to a product" do
      # Arrange
      expect(orderitem.product).must_be_instance_of Product
      expect(orderitem.product).must_equal product
    end

    it "belongs to an order" do
      expect(orderitem.order).must_be_instance_of Order
      expect(orderitem.order).must_equal order
    end
  end

  describe "quantity validations" do
    it "must be greater than or equal to 0" do
      orderitem.quantity = -1
      orderitem.save

      expect(orderitem.valid?).must_equal false
      expect(orderitem.errors.messages).must_include :quantity
      expect(orderitem.errors.messages[:quantity]).must_equal ["must be greater than or equal to 0"]
    end

    it "must be an integer" do
      orderitem.quantity = "hotdog"
      orderitem.save

      expect(orderitem.valid?).must_equal false
      expect(orderitem.errors.messages).must_include :quantity
      expect(orderitem.errors.messages[:quantity]).must_equal ["is not a number"]
    end
  end
end
