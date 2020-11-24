require "test_helper"

describe OrderitemsController do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end
  #

  # describe "show" do
  #   it "responds with success when showing an existing valid orderitem" do
  #     oi1 = orderitems(:shipped1)
  #     get orderitem_path(oi1.id)
  #
  #     must_respond_with :success
  #   end
  #
  #   it "responds with redirect with an invalid orderitem id" do
  #     get orderitem_path(-1)
  #
  #     must_respond_with :redirect
  #     must_redirect_to root_path
  #   end
  # end

    describe "create" do
      it "can create a new orderitem and cart with valid information and redirect for existing cart" do
        oi_hash = {
            product_id: products(:product1).id,
            orderitem: {
              quantity: 3
            }
        }

        expect {
          post orderitems_path, params: oi_hash
        }.must_change "Orderitem.count", 1

        new_oi = Orderitem.last
        expect(new_oi.quantity).must_equal 3
        expect(new_oi.order).must_be_kind_of Order
        expect(new_oi.product).must_equal products(:product1)

        must_respond_with :redirect
        must_redirect_to cart_path
      end

      it "won't create an invalid trip if product.nil" do
        oi_hash = {
            # product_id: products(:product1).id,
            orderitem: {
                quantity: 3
            }
        }

        expect {
          post orderitems_path, params: oi_hash
        }.wont_change "Orderitem.count"


        expect(flash[:warning]).must_equal 'You must select a valid product'
        must_respond_with :redirect
      end

      it "won't create an invalid trip if more products requested than in stock" do
        oi_hash = {
            product_id: products(:product1).id,
            orderitem: {
                quantity: 20
            }
        }

        expect {
          post orderitems_path, params: oi_hash
        }.wont_change "Orderitem.count"


        expect(flash[:warning]).must_equal "Only #{products(:product1).stock} items left in stock"
        must_respond_with :redirect
      end


    end




  end


