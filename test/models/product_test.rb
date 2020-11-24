require "test_helper"

describe Product do
  describe "instantiation" do
      it "can be instantiated" do
        # Arrange
        product = Product.new

        # Assert
        expect(product).must_be_instance_of Product
      end

      #
      # it "will have the required fields" do
      #   # Arrange
      #   new_driver.save
      #   driver = Driver.first
      #   [:name, :vin, :available].each do |field|
      #
      #     # Assert
      #     expect(driver).must_respond_to field
      #   end
      # end
  end


  describe "relationships" do
    it "product can have multiple reviews" do

      # Arrange test as merchant in users.yml
      product = products(:product2)

      # Assert relationship to review model
      expect(product.reviews.count).must_equal 3
      # new_passenger.trips.each do |trip|
      #   expect(trip).must_be_instance_of Trip
    end

    it "product can have 0 reviews" do
      # Arrange
      product = products(:product4)

      # Assert
      expect(product.reviews.count).must_equal 0
    end

    it "product has a category" do

      # Arrange product1
      product = products(:product1)

      # Assert
      expect(product.categories.count).must_equal 1
    end

    it "product has multiple categories" do

      # Arrange
      product = products(:product2)

      # Assert
      expect(product.categories.count).must_equal 2
    end

    it "product can have 0 categories" do

      # Arrange
      product = products(:product5)

      # Assert
      expect(product.categories.count).must_equal 0
    end

    # it "product is related to a merchant" do
    #
    #   # Arrange
    #   product = products(:product1)
    #
    #   # Assert
    #   expect(product.merchant).must_equal "test"
    # end
  end

  describe "validations" do
    it "can be instantiated and is valid when all required fields are present" do
      # Arrange
      @product = products(:product1)

      # Act
      product_validity = @product.valid?

      # Assert
      expect(product_validity).must_equal true
    end

    it "is invalid without name" do
      # Arrange
      @product = products(:product1)
      @product.name = nil

      #Act
      nameless_product = @product.valid?

      # Assert
      expect(nameless_product).must_equal false
      expect(@product.errors.messages).must_include :name
    end

    it "is invalid without category" do
      # Arrange
      @product = products(:product1)
      @product.description = nil

      #Act
      descriptionless_product = @product.valid?

      # Assert
      expect(descriptionless_product).must_equal false
      expect(@product.errors.messages).must_include :description
    end
  end


  #   describe "custom methods" do
  #     # Your tests here
  #   end
  # end



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
