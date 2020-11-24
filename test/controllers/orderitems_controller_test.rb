require "test_helper"

describe OrderitemsController do
    describe "create" do
      it "can create a new orderitem and cart with valid information and redirect to cart" do
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

      it "won't create an invalid trip if 0 products requested " do
        oi_hash = {
            product_id: products(:product1).id,
            orderitem: {
                quantity: 0
            }
        }

        expect {
          post orderitems_path, params: oi_hash
        }.wont_change "Orderitem.count"


        expect(flash[:warning]).must_equal 'Cannot add 0 items'
        must_respond_with :redirect
      end

      it "will update instead of create a new oi when already in cart" do
          oi_hash1 = {
              product_id: products(:product1).id,
              orderitem: {
                  quantity: 3
              }
          }

          expect {
            post orderitems_path, params: oi_hash1
          }.must_change "Orderitem.count", 1

          oi_hash2 = {
              product_id: products(:product1).id,
              orderitem: {
                  quantity: 2
              }
          }

          expect {
            post orderitems_path, params: oi_hash2
          }.wont_change "Orderitem.count"

          new_oi = Orderitem.last
          expect(new_oi.quantity).must_equal 5
          expect(new_oi.order).must_be_kind_of Order
          expect(new_oi.product).must_equal products(:product1)

          must_respond_with :redirect
          must_redirect_to cart_path
      end
    end

    describe "update" do
      before do
        get cart_path
      end

      it "will update quantity with valid input" do

        oi = orderitems(:waiting2)

        oi_edit_hash = {
                quantity: 4
        }

        puts "before"
        puts oi.id
        puts oi.quantity

        expect {
          patch orderitem_path(oi.id), params: oi_edit_hash
        }.wont_change "Orderitem.count"

        puts "after"
        puts oi.id
        puts oi.quantity

        expect(oi.quantity).must_equal 4

        expect(flash[:success]).must_equal "Successfully updated #{orderitems(:waiting2).product.name} quantity!"
        must_respond_with :redirect
      end
    end

    describe "destroy" do
      it "will delete an orderitem that exists and redirect" do
        oi = orderitems(:waiting1)

        expect {
          delete orderitem_path(oi.id)
        }.must_change "Orderitem.count", 1

        expect(flash[:success]).must_equal "Successfully removed #{oi.product.name} from cart!"
        must_respond_with :redirect
      end

      it "will not delete an orderitem that doesn't exit, will redirect" do
        expect {
          delete orderitem_path(-1)
        }.wont_change "Orderitem.count"

        expect(flash[:warning]).must_equal 'A problem occurred: could not locate order item'
        must_respond_with :redirect

      end

    end





  end


