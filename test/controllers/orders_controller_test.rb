# require "test_helper"
#
# describe OrdersController do
#   before do
#     @merchant = Merchant.create(username: 'test merchant', email: 'test_merchant@email.com')
#     @product = Product.create(name: 'test plant', description: 'test description', price: 5.0, photo_url: "url.com/plant", stock: 6, merchant_id: @merchant.id)
#   end
#
#   let(:order) do
#     Order.create(status: 'paid', name: "buyer", email: "buyer@email.com", address: "123 Ada Court", credit_card_number: '123456789', cvv: '123', expiration_date: '2/21', total: 20)
#   end
#
#   describe "show" do
#     it "responds with success when showing an existing valid order for an unauthenticated user" do
#       order.save
#
#       get order_path(order.id)
#       must_respond_with :success
#     end
#
#     it "responds with an error message if given an invalid id" do
#       get order_path(-1)
#
#       expect(flash[:error]).must_equal "Sorry, that order cannot be found"
#       must_respond_with :redirect
#     end
#   end
#
#   describe "merchant show" do
#     it "responds with success if the merchant is logged in and the order contains a product of theirs" do
#       # merchant.save
#
#
#     end
#
#   end
#
#   describe "edit" do
#     it 'responds with success when getting the edit page for an existing, valid order' do
#       order.save
#       order = Order.find_by(id: session[:order_id])
#       id = order.id
#       # id = session[:order_id]
#       get edit_order_path(id)
#
#       must_respond_with :success
#     end
#
#     it 'responds with redirect when getting the edit page for a non-existing order' do
#       get edit_order_path(-1)
#
#       must_respond_with :redirect
#     end
#   end
#
#   describe "update" do
#     let(:new_order_hash) do
#       {
#           order: {
#               status: 'paid',
#               name: "buyer",
#               email: "buyer@email.com",
#               address: "123 Ada Court",
#               credit_card_number: '123456789',
#               cvv: '123',
#               expiration_date: '2/21',
#               total: 30
#           }
#       }
#     end
#
#     it 'can update an existing order with valid information accurately, and redirect' do
#       order.save
#       order = Order.find_by(id: session[:order_id])
#       id = order.id
#
#       expect do
#         patch order_path(id), params: new_order_hash
#       end.wont_change 'Order.count'
#
#       must_redirect_to order_path
#
#       # order = Order.find_by(id: id)
#       expect(order.status).must_equal new_order_hash[:order][:status]
#       expect(order.name).must_equal new_order_hash[:order][:name]
#       expect(order.email).must_equal new_order_hash[:order][:email]
#       expect(order.cvv).must_equal new_order_hash[:order][:cvv]
#       expect(order.expiration_date).must_equal new_order_hash[:order][:expiration_date]
#       expect(order.expiration_date).must_equal new_order_hash[:order][:total]
#     end
#
#     it 'does not update any order if given an invalid id, and responds with a 404' do
#       id = -1
#
#       expect do
#         patch order_path(id), params: new_order_hash
#       end.wont_change 'Order.count'
#
#       must_respond_with :redirect
#     end
#   end
#
#   describe "cart" do
#     it "can get the cart" do
#       get cart_path
#       must_respond_with :success
#     end
#   end
#
#   describe "checkout" do
#     it "confirms the order if the cart can be checked out" do
#
#     end
#
#     it "cannot confirm the order if the cart cannot be checked out" do
#
#     end
#   end
#
#   describe "destroy" do
#     it "destroys the order instance in db when order exists, then redirects to root_path" do
#       order.save
#
#       expect do
#         delete order_path(order.id)
#       end.must_change 'Orderitems.count', -1
#
#       must_respond_with :redirect
#       must_redirect_to root_path
#     end
#
#     it 'does not change the db when the order does not exist, then responds with redirect' do
#       id = -1
#
#       expect do
#         delete order_path(id)
#       end.wont_change 'Order.count'
#
#       must_respond_with :redirect
#     end
#   end
# end
