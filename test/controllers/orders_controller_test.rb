require "test_helper"

describe OrdersController do
  let(:order) do
    Order.create(status: 'paid', name: "buyer", email: "buyer@email.com", address: "123 Ada Court", credit_card_number: '123456789', cvv: '123', expiration_date: '2/21', total: 20)
  end

  before do
    @merchant = Merchant.create(username: 'test merchant', email: 'test_merchant@email.com', provider: "github", uid: 11111112)
    @product = Product.create(name: 'test plant', description: 'test description', price: 5.0, photo_url: "url.com/plant", stock: 6, merchant_id: @merchant.id)
    @orderitem = Orderitem.create(quantity: 2, order_id: order.id, product_id: @product.id, shipped: false)
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

      get merchant_show_path(id: order.id)
      must_respond_with :success
    end

    it "redirects to the root path if the merchant is not logged in" do
      get merchant_show_path(id: order.id)
      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "redirects to the root path if the order cannot be found" do
      get merchant_show_path(id: -1)
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end


  describe "cart" do
    it "can get the cart" do
      get cart_path
      must_respond_with :success
    end
  end

  describe "checkout" do
    before do
      get cart_path
    end

    it "confirms the order if the cart can be checked out and redirects" do
      orderitem = { orderitem: {quantity: 5, product_id: @product.id, shipped: false } }

      post orderitems_path(orderitem)
      # add an order item
      order_params = {order: {status: "pending", name: "test", email: "test@email.com",
                              address: "123 test lane", credit_card_number: "123456789", cvv: "123", expiration_date: "09/22", zip_code: "12345"} }
      expect {
        patch cart_path(order_params)
      }.wont_change 'Order.count' # won't change because cart is created in before block

      expect(flash[:success]).must_equal "Your order has been confirmed."
      order = Order.last
      must_redirect_to order_path(order.id)
    end

    it "cannot confirm the order if the cart cannot be checked out" do
      orderitem = { orderitem: {quantity: 5, product_id: @product.id, shipped: false } }

      post orderitems_path(orderitem)
      # add an order item
      order_params = {order: {status: "pending", name: nil, email: "test@email.com",
                              address: "123 test lane", credit_card_number: "123456789", cvv: "123", expiration_date: "09/22", zip_code: "12345"} }
      expect {
        patch cart_path(order_params)
      }.wont_change 'Order.count' # won't change because cart is created in before block

      order = Order.last
      must_respond_with :bad_request
      expect(flash.now[:errors]).wont_be_nil
    end
  end

  describe "destroy" do
    before do
      get cart_path
    end

    it "changes the order status to cancelled when the order exists and can be cancelled, then responds with redirect" do
      order.save
      order_id = order.id

      expect do
        delete order_path(order_id)
      end.wont_change 'Order.count'

      order = Order.find_by_id(order_id)

      must_respond_with :redirect
      must_redirect_to order_path
      expect(order.status).must_equal "cancelled"
    end

    it 'does not change the order status when the order does not exist, then responds with redirect' do
      id = -1

      expect do
        delete order_path(id)
      end.wont_change 'Order.count'

      must_respond_with :redirect
      must_redirect_to root_path
    end
  end
end
