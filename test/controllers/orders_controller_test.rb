require "test_helper"

describe OrdersController do
  before do
    @merchant = Merchant.create(username: 'test merchant', email: 'test_merchant@email.com')
    @product = Product.create(name: 'test plant', description: 'test description', price: 5.0, photo_url: "url.com/plant", stock: 6, merchant_id: @merchant.id)
  end

  let(:order) do
    Order.create(status: 'paid', name: "buyer", email: "buyer@email.com", address: "123 Ada Court", credit_card_number: '123456789', cvv: '123', expiration_date: '2/21', total: 20)
  end

  describe "show" do
    it "responds with success when showing an existing valid order for an unauthenticated user" do
      order.save

      get order_path(order.id)
      must_respond_with :success
    end

    it "responds with an error message if given an invalid id" do
      get order_path(-1)

      expect(flash[:error]).must_equal "Sorry, that order cannot be found"
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe "merchant show" do
    it "responds with success if the merchant is logged in and the order contains a product of theirs" do
      perform_login(@merchant)


    end


  end


  describe "cart" do
    it "can get the cart" do
      get cart_path
      must_respond_with :success
    end
  end

  describe "checkout" do
    it "confirms the order if the cart can be checked out and redirects" do

    end

    it "cannot confirm the order if the cart cannot be checked out" do

    end
  end

  describe "destroy" do
    it "changes the order status to cancelled when the order exists and can be cancelled, then responds with redirect" do
      order.save

      expect do
        delete order_path(order.id)
      end.wont_change 'Order.count'

      must_respond_with :redirect
      must_redirect_to order_path
    end

    it 'does not change the order status when the order does not exist, then responds with redirect' do
      id = -1

      expect do
        delete order_path(id)
      end.wont_change 'Order.count'

      must_respond_with :redirect
      must_redirect_to order_path
    end
  end
end
