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
      it "returns total revenue of all items in orders (if no filter specified or invalid filter specified)" do
        total_revenue = merchants(:test).total_revenue
        total = 0
        orderitems = Orderitem.where(product: [products(:product1), products(:product2)])

        orderitems.each do |orderitem|
          total += orderitem.quantity * orderitem.product.price
        end

        expect(total_revenue).must_be_close_to total
      end

      it "returns total revenue of items on orders filtered by status" do
        total_revenue = merchants(:user).total_revenue(status: 'pending')
        total = 0
        orders = Order.where(status: 'pending')
        orderitems = orders.where(orderitems: [orderitems(:waiting0), orderitems(:waiting1)]) # this part is why we can't just loop

        orderitems.each do |order|
          order.orderitems.each do |orderitem|
            if orderitem.merchant == merchants(:user)
              total += orderitem.quantity * orderitem.product.price
            end
          end
        end
        expect(total_revenue).must_be_close_to total
      end
    end
    describe "get orders" do
      it "returns {} if there are no orders" do
        Order.delete_all
        Orderitem.delete_all

        all_orders = merchants(:test).get_orders

        expect(all_orders).must_be_empty
        expect(all_orders).must_be_kind_of Hash
      end
      it "returns all orders w/ order items (if no filter specified or invalid filter specified)" do
        orders = merchants(:test).get_orders

        # pull info another way
        products = Product.where(merchant: merchants(:test))
        orderitems = Orderitem.where(product: products)
        orders2 = Order.where(orderitems: orderitems)
        p orders
        # num of key/value pairs from method must equal number of orders
        expect(orders2.count).must_equal orders.size()

        # with this loop need to check:
        # - keys of get_orders return match orders in orders2
        # - keys are a type of order
        # - values aka array of orderitems does not contain order items belonging to another merchant.

        orders.each do |order, orderitems|
          # keys of get_orders return match orders in orders2 & are type of order
          expect(orders2).must_include order # <- we derived orders2 from Order, so this checks both
          orderitems.each do |orderitem|
            expect(orderitem.merchant).must_equal merchants(:test) # check orderitems merchant
          end
        end
      end

      it "returns orders w/orderitems filtered by status" do
        orders = merchants(:user).get_orders(status: 'pending')

        # pull info another way
        products = Product.where(merchant: merchants(:user))
        orderitems = Orderitem.where(product: products)
        orders2 = Order.where(orderitems: orderitems, status: 'pending')

        # num of key/value pairs from method must equal number of orders
        expect(orders2.count).must_equal orders.size()

        # with this loop need to check:
        # - keys of get_orders return match orders in orders2
        # - keys are a type of order
        # - values aka array of orderitems does not contain order items belonging to another merchant.
        # - ALSO check status of order

        orders.each do |order, orderitems|
          # keys of get_orders return match orders in orders2 & are type of order
          expect(orders2).must_include order # <- we derived orders2 from Order, so this checks both
          expect(order.status).must_equal 'pending'
          orderitems.each do |orderitem|
            expect(orderitem.merchant).must_equal merchants(:user) # check orderitems merchant
          end
        end
      end
    end

    describe "build from github" do
      it "correctly assigns fields from auth hash when github name is present" do
        # even though build from github doesn't save, the model validation checks for uniqueness
        # we have to build a new merchant with unique attributes (except provider)
        new_merchant = Merchant.new(provider: 'github', uid: 5432154, username: "new", email: "new@new.com")
        auth_hash = mock_auth_hash(new_merchant)

        new_mer_saved = Merchant.build_from_github(auth_hash)

        expect(new_mer_saved.valid?).must_equal true

        expect(new_mer_saved.provider).must_equal new_merchant.provider
        expect(new_mer_saved.uid).must_equal new_merchant.uid
        expect(new_mer_saved.username).must_equal new_merchant.username
        expect(new_mer_saved.provider_name).must_equal new_merchant.username
        expect(new_mer_saved.email).must_equal new_merchant.email
        expect(new_mer_saved.provider_email).must_equal new_merchant.email
      end

      it "correctly assigns username to nickname when name is NOT present but nickname is " do
        # we need to make a special hash that has a name but no nickname just for this test
        # this isn't built into mock_auth_hash (nor does it make sense to be) so we have to make it ourselves
        auth_hash = {provider: 'github',
                     uid: 1919191919,
                     info: {
                            email: "noname@name.com",
                            name: nil,
                            nickname: "nickname exists"
                            }
                     }
        new_mer_saved = Merchant.build_from_github(auth_hash)

        expect(new_mer_saved.valid?).must_equal true

        expect(new_mer_saved.provider).must_equal auth_hash[:provider]
        expect(new_mer_saved.uid).must_equal auth_hash[:uid]
        expect(new_mer_saved.username).must_equal auth_hash[:info][:nickname]
        expect(new_mer_saved.provider_name).must_equal auth_hash[:info][:nickname]
        expect(new_mer_saved.email).must_equal auth_hash[:info][:email]
        expect(new_mer_saved.provider_email).must_equal auth_hash[:info][:email]

      end
    end
  end
end
