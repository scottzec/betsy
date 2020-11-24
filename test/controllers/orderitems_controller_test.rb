require "test_helper"

describe OrderitemsController do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end
  #

  describe "show" do
    it "responds with success when showing an existing valid orderitem" do
      oi1 = orderitems(:shipped1)
      get orderitem_path(oi1.id)

      must_respond_with :success
    end

    it "responds with redirect with an invalid orderitem id" do
      get orderitem_path(-1)

      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  require "test_helper"

  describe OrderitemsController do
    # it "does a thing" do
    #   value(1+1).must_equal 2
    # end
    #

    describe "show" do
      it "responds with success when showing an existing valid orderitem" do
        oi1 = orderitems(:shipped1)
        get orderitem_path(oi1.id)

        must_respond_with :success
      end

      it "responds with redirect with an invalid orderitem id" do
        get orderitem_path(-1)

        must_respond_with :redirect
        must_redirect_to root_path
      end
    end

    describe "create" do
      it "can create a new orderitem and cart with valid information and redirect for existing cart" do
        oi_hash = {
            product_id: products(:product1).id,
            quantity: 3
        }

        expect {
          post orderitem_path, params: oi_hash
        }.must_change "Orderitem.count", 1

        new_oi = Orderitem.last
        expect(new_oi.quantity).must_equal 3
        expect(new_oi.order).must_equal orders(:pending)
        expect(new_oi.product).must_equal products(:product1)
        expect(new_trip.driver).must_equal driver

        must_respond_with :redirect
        must_redirect_to cart_path
      end

      # it "won't create an invalid trip if no drivers available and will redirect" do
      #   driver.available = false
      #   driver.save
      #
      #   # Act-Assert
      #   expect {
      #     post passenger_trips_path(passenger.id)
      #   }.wont_change "Trip.count"
      #
      #   must_respond_with :temporary_redirect
      #   must_redirect_to passenger_path(passenger.id)
      # end
    end




  end



end

