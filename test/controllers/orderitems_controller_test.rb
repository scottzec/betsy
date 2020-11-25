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
        expect(new_oi.shipped).must_equal false

        must_respond_with :redirect
        must_redirect_to cart_path
      end

      it "won't create if merchant logged in and tries to buy own product" do
        perform_login(merchants(:test))

        oi_hash = {
            product_id: products(:product1).id,
            orderitem: {
                quantity: 3
            }
        }

        expect {
          post orderitems_path, params: oi_hash
        }.wont_change "Orderitem.count"


        expect(flash[:warning]).must_equal 'You cannot add your own product to your cart'
        must_respond_with :redirect
      end

      it "will create if merchant logged in and buys another merchants product" do
        perform_login(merchants(:user))


        oi_hash = {
            product_id: products(:product5).id,
            orderitem: {
                quantity: 2
            }
        }

        expect {
          post orderitems_path, params: oi_hash
        }.must_change "Orderitem.count", 1


        new_oi = Orderitem.last
        expect(new_oi.quantity).must_equal 2
        expect(new_oi.order).must_be_kind_of Order
        expect(new_oi.product).must_equal products(:product5)
        expect(new_oi.shipped).must_equal false

        must_respond_with :redirect
        must_redirect_to cart_path
      end

      it "won't create an invalid trip if product .nil" do
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

      it "won't create an invalid oi if more products requested than in stock" do
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

      it "won't create an invalid oi if 0 products requested " do
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

        expect {
          patch orderitem_path(oi.id), params: oi_edit_hash
        }.wont_change "Orderitem.count"

        oi.reload

        expect(oi.quantity).must_equal 4

        expect(flash[:success]).must_equal "Successfully updated #{orderitems(:waiting2).product.name} quantity!"
        must_respond_with :redirect
      end

      it "will delete orderitem with 0 input" do

        oi = orderitems(:waiting2)

        oi_edit_hash = {
            quantity: 0
        }

        expect {
          patch orderitem_path(oi.id), params: oi_edit_hash
        }.must_change "Orderitem.count", 1


        expect(flash[:success]).must_equal "Removed #{oi.product.name} from cart"
        must_respond_with :redirect
      end

      it "will delete orderitem with non-numeric input" do

        oi = orderitems(:waiting2)

        oi_edit_hash = {
            quantity: "hotdog"
        }

        expect {
          patch orderitem_path(oi.id), params: oi_edit_hash
        }.must_change "Orderitem.count", 1


        expect(flash[:success]).must_equal "Removed #{oi.product.name} from cart"
        must_respond_with :redirect
      end

      it "will not update quantity with invalid input" do

        oi = orderitems(:waiting2)

        oi_edit_hash = {
            quantity: 400
        }

        expect {
          patch orderitem_path(oi.id), params: oi_edit_hash
        }.wont_change "Orderitem.count"

        oi.reload

        expect(oi.quantity).must_equal 2

        expect(flash[:warning]).must_equal "Only #{oi.product.stock} items left in stock"
        must_respond_with :redirect
      end

      it "will not update orderitem that does not exist" do
        oi_edit_hash = {
            quantity: 400
        }

        expect {
          patch orderitem_path(-1), params: oi_edit_hash
        }.wont_change "Orderitem.count"

        expect(flash[:warning]).must_equal 'A problem occurred: could not find item'
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

    describe "mark_shipped" do
      it "will redirect if oi nil" do
        perform_login(merchants(:user))

        expect {
          patch mark_shipped_path(-1)
        }.wont_change "Orderitem.count"

        expect(flash[:warning]).must_equal 'A problem occurred: could not locate order item'
        must_respond_with :redirect
      end

      it "will not allow to mark_shipped if not logged in" do
        oi = orderitems(:waiting0)

        expect {
          patch mark_shipped_path(oi.id)
        }.wont_change "Orderitem.count"

        expect(flash[:warning]).must_equal "You must be logged in to view this section"
        must_respond_with :redirect
      end

      it "will let merchant mark_shipped oi assoc with their product" do
        perform_login(merchants(:test))

        oi = orderitems(:waiting3)

        expect {
          patch mark_shipped_path(oi.id)
        }.wont_change "Orderitem.count"

        oi.reload
        expect(oi.shipped).must_equal true

        must_respond_with :redirect
      end

      it "order must be paid to ship item" do
        perform_login(merchants(:user))

        oi = orderitems(:waiting0)

        puts merchants(:user).id
        puts oi.product.merchant.id

        expect {
          patch mark_shipped_path(oi.id)
        }.wont_change "Orderitem.count"

        oi.reload
        puts oi.product.merchant.id
        expect(oi.shipped).must_equal false

        expect(flash[:warning]).must_equal 'Order is not confirmed, do not ship product'
        must_respond_with :redirect
      end

      it "will not let merchant mark_shipped oi assoc with another's product" do
        perform_login(merchants(:test))

        oi = orderitems(:waiting0)

        expect {
          patch mark_shipped_path(oi.id)
        }.wont_change "Orderitem.count"

        oi.reload
        expect(oi.shipped).must_equal false

        expect(flash[:warning]).must_equal 'You cannot ship a product that does not belong to you'
        must_respond_with :redirect
      end

      it "can only mark shipped once" do
        perform_login(merchants(:user))

        oi = orderitems(:shipped1)

        expect {
          patch mark_shipped_path(oi.id)
        }.wont_change "Orderitem.count"

        oi.reload
        expect(oi.shipped).must_equal true

        expect(flash[:warning]).must_equal 'Product already marked shipped'
        must_respond_with :redirect
      end

      it "will update order status to complete if final oi is marked shipped" do
        perform_login(merchants(:test))

        order = orders(:paid)
        oi1 = orderitems(:waiting2)
        oi2 = orderitems(:waiting3)

        expect {
          patch mark_shipped_path(oi1.id)
        }.wont_change "Orderitem.count"

        expect {
          patch mark_shipped_path(oi2.id)
        }.wont_change "Orderitem.count"

        order.reload
        oi1.reload
        oi2.reload


        expect(oi1.shipped).must_equal true
        expect(oi2.shipped).must_equal true
        expect(order.status).must_equal "complete"

        must_respond_with :redirect
      end
    end





  end


