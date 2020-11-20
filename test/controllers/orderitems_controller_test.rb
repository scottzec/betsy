require "test_helper"

describe OrderitemsController do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end
  #
  let (:product) {
    Product.create!(name: "orchid",
                   description: "pretty fragile flower",
                   price: 21.00,
                   photo_url: nil,
                   stock: 30,
                   merchant_id: 1)
  }

  let (:order) {
    Order.create!(status: "paid",
                 name: "Buy Buyerson",
                 email: "buy@buy.com",
                 address: "1234 buy st. s., Buy, OR",
                 credit_card_number: "1234 5678 9101 1121",
                 zip_code: "12345-1234",
                 total: 84.00)
  }

  let (:orderitem) {
    Orderitem.create!(quantity: 4,
                     product_id: product.id,
                     order_id: order.id)
  }

  describe "show" do
    # Your tests go here
    it "responds with success when showing an existing valid trip" do
      get orderitem_path(orderitem.id)

      must_respond_with :success
    end

    it "responds with redirect with an invalid trip id" do
      get orderitem_path(-1)

      must_respond_with :redirect
      must_redirect_to root_path
    end

  end


end

