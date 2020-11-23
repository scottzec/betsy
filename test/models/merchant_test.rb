require "test_helper"

describe Merchant do
  it "can be instantiated" do
    expect(merchants(:test).valid?).must_equal true
  end
  it "will have the required fields" do
    mer = Merchant.first
    [:provider, :uid, :email, :username, :provider_email, :provider_name].each do |field|
      expect(mer).must_respond_to field
    end
  end

  describe "relations" do
    it "can have many products" do
      mer1 = products(:product1).merchant
      mer2 = products(:product2).merchant

      expect(mer1).must_equal mer2
    end
    it "can get information about a product through its relation" do
      product = merchants(:test).products.find_by_id(products(:product1).id)

      expect(product.name).must_equal products(:product1).name
      expect(product.description).must_equal products(:product1).description
      expect(product.price).must_be_close_to products(:product1).price
      expect(product.stock).must_equal products(:product1).stock
      expect(product.photo_url).must_equal products(:product1).photo_url
      expect(product.merchant_id).must_equal products(:product1).merchant_id
    end
    it "can have many orderitems" do

    end
    it "can get information about an orderitem through its relation" do

    end
  end

  describe "validations" do
    it "must have a username" do

    end

    it "must have a unique username" do

    end

    it "must have an email" do

    end

    it "must have a unique email" do

    end
  end

  describe "custom methods" do
    describe "total revenue" do
      it "returns 0 if there are no order items" do

      end
    end
    describe "get orders" do

    end
    describe "build from github" do

    end
  end
end
