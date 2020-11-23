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
      mer1 = orderitems(:waiting2).merchant
      mer2 = orderitems(:waiting3).merchant

      expect(mer1).must_equal mer2
    end
    it "can get information about an orderitem through its relation" do
      orderitem = merchants(:test).orderitems.find_by_id(orderitems(:shipped2).id)

      expect(orderitem.order).must_equal orderitems(:shipped2).order
      expect(orderitem.product).must_equal orderitems(:shipped2).product
      expect(orderitem.quantity).must_equal orderitems(:shipped2).quantity
      expect(orderitem.shipped).must_equal orderitems(:shipped2).shipped
    end
  end

  describe "validations" do
    it "must have a username" do
      no_name = Merchant.new(username: nil, email: "email@email.com")

      expect(no_name.valid?).must_equal false
      expect(no_name.errors.messages[:username]).must_include "can't be blank"
    end

    it "must have a unique username" do
      testing_already_in_fixture = Merchant.new(username: "testing", email: "email@email.com")

      expect(testing_already_in_fixture.valid?).must_equal false
      expect(testing_already_in_fixture.errors.messages[:username]).must_include "has already been taken"
    end

    it "must have an email" do
      no_name = Merchant.new(username: "usernotblank", email: nil)

      expect(no_name.valid?).must_equal false
      expect(no_name.errors.messages[:email]).must_include "can't be blank"
    end

    it "must have a unique email" do
      email_already_in_fixture = Merchant.new(username: "newname", email: "test@test.com")

      expect(email_already_in_fixture.valid?).must_equal false
      expect(email_already_in_fixture.errors.messages[:email]).must_include "has already been taken"
    end
  end

  describe "custom methods" do
    describe "total revenue" do
      it "returns 0 if there are no order items" do
        Order.delete_all
        Orderitem.delete_all

        total_revenue = merchants(:test).total_revenue

        expect(total_revenue).must_be_close_to 0
      end
      it "returns total revenue of all items in order (if no filter specified or invalid filter specified)" do

      end

      it "returns total revenue of items on pending order ONLY when pending status applied" do

      end

      it "returns total revenue items on paid order ONLY when paid status applied" do

      end

      it "returns total revenue of items on complete order ONLY when complete status applied" do

      end

      it "returns total revenue of items on cancelled order ONLY when cancelled status applied" do

      end
    end
    describe "get orders" do
      it "returns [] if there are no orders" do
        Order.delete_all
        Orderitem.delete_all

        all_orders = merchants(:test).get_orders

        expect(all_orders).must_be_empty
        expect(all_orders).must_be_kind_of Hash
      end
      it "returns all orders w/ order items (if no filter specified or invalid filter specified)" do

      end

      it "returns only pending orders w/orderitems ONLY when pending status applied" do

      end

      it "returns only paid orders w/orderitems ONLY when paid status applied" do

      end

      it "returns only complete orders w/orderitems ONLY when complete status applied" do

      end

      it "returns only cancelled orders w/orderitemsONLY when cancelled status applied" do

      end
    end

    describe "build from github" do
      it "correctly assigns fields from auth hash when github name is present" do

      end

      it "correct assigns username to nickname when name is NOT present but nickname is " do
        
      end
    end
  end
end
