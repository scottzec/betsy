require "test_helper"

describe Product do
  describe "relationships" do
    it "product can have multiple reviews" do

      # Arrange user3 in users.yml
      product = products(:product2)

      # Assert relationship to vote model, 3 votes by user3 in votes.yml
      expect(product.reviews.count).must_equal 3
    end

    it "product has a category" do

      # Arrange user3 in users.yml
      product = products(:product2)

      # Assert relationship to vote model, 3 votes by user3 in votes.yml
      expect(product.reviews.count).must_equal 3
    end
  end
  
  
  # let (:new_product) {
  #   Product.new(name: "Kari", vin: "123", available: true)
  # }
  # before do
  #   Driver.create(name: "Kari",
  #                 vin: "123",
  #                 available: true)
  # end
  #
  # # let (:driver_hash) {
  # #   {
  # #       driver: {
  # #           name: "Sisi",
  # #           vin: "321",
  # #           available: false
  # #       }
  # #   }
  # # }
  # before do
  #   @product = Product.new
  # end
#
#   it "can be instantiated" do
#     # Act
#     created_product = @work.valid?
#
#     # Assert
#     expect(created_product).must_equal true
#   end
#
#   it "will have the required fields" do
#     # Your code here
#   end
#
#   describe "relationships" do
#     # Your tests go here
#   end
#
#   describe "validations" do
#     it "created product is valid" do
#       # Act
#       created_product = @work.valid?
#
#       # Assert
#       expect(created_product).must_equal true
#     end
#   end
#
#   # Tests for methods you create should go here
#   describe "custom methods" do
#     # Your tests here
#   end
# end


# require "test_helper"
#
# describe Driver do
#   let (:new_driver) {
#     Driver.new(name: "Kari", vin: "123", available: true)
#   }
#   it "can be instantiated" do
#     # Assert
#     expect(new_driver.valid?).must_equal true
#   end
#
#   it "will have the required fields" do
#     # Arrange
#     new_driver.save
#     driver = Driver.first
#     [:name, :vin, :available].each do |field|
#
#       # Assert
#       expect(driver).must_respond_to field
#     end
#   end
#
#   describe "relationships" do
#     it "can have many trips" do
#       # Arrange
#       new_driver.save
#       new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
#       trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1234)
#       trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 6334)
#
#       # Assert
#       expect(new_driver.trips.count).must_equal 2
#       new_driver.trips.each do |trip|
#         expect(trip).must_be_instance_of Trip
#       end
#     end
#   end
#
#   describe "validations" do
#     it "must have a name" do
#       # Arrange
#       new_driver.name = nil
#
#       # Assert
#       expect(new_driver.valid?).must_equal false
#       expect(new_driver.errors.messages).must_include :name
#       expect(new_driver.errors.messages[:name]).must_equal ["can't be blank"]
#     end
#
#     it "must have a VIN number" do
#       # Arrange
#       new_driver.vin = nil
#
#       # Assert
#       expect(new_driver.valid?).must_equal false
#       expect(new_driver.errors.messages).must_include :vin
#       expect(new_driver.errors.messages[:vin]).must_equal ["can't be blank"]
#     end
#   end
#
#   # Tests for methods you create should go here
#   describe "custom methods" do
#     describe "average rating" do
#       # Your code here
#     end
#
#     describe "total earnings" do
#       # Your code here
#     end
#
#     describe "can go on/off line" do
#       driver = Driver.first
#       it "can access the availability path" do
#         # Act
#         patch availability_path(driver.id)
#
#         # Assert
#         must_redirect_to root_path
#       end
#       it "will not change other statistics" do
#         expect {
#           patch availability_path(driver.id)
#         }.wont_change "Driver.count", Driver.name
#
#         must_redirect_to root_path
#       end
#     end
#
#
#     # You may have additional methods to test
#   end
# end
end
