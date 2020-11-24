require "test_helper"

describe Product do
  describe "instantiation" do
      it "can be instantiated" do
        # Arrange
        product = Product.new

        # Assert
        expect(product).must_be_instance_of Product
      end
  end


  describe "will have required fields" do
    it "a product has each of the fields that are req'd (excluding categories which is optional)" do
        # Arrange
        product = products(:product3)
        [:name, :description, :price, :photo_url, :stock].each do |field|

          # Assert
          expect(product).must_respond_to field
        end
      end
  end


  describe "relationships" do
    it "product can have multiple reviews" do

      product = products(:product2)

      # Assert relationship to review model
      expect(product.reviews.count).must_equal 3

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

    it "is invalid without description" do
      # Arrange
      @product = products(:product1)
      @product.description = nil

      #Act
      descriptionless_product = @product.valid?

      # Assert
      expect(descriptionless_product).must_equal false
      expect(@product.errors.messages).must_include :description
    end

    it "is invalid without price" do
      # Arrange
      @product = products(:product1)
      @product.price = nil

      #Act
      priceless_product = @product.valid?

      # Assert
      expect(priceless_product).must_equal false
      expect(@product.errors.messages).must_include :price
    end

    it "is invalid with a price that isn't numerical" do
      # Arrange
      @product = products(:product1)
      @product.price = "price"

      #Act
      priceless_product = @product.valid?

      # Assert
      expect(priceless_product).must_equal false
      expect(@product.errors.messages).must_include :price
    end

    it "is invalid without photo url" do
      # Arrange
      @product = products(:product1)
      @product.photo_url = nil

      #Act
      photoless_product = @product.valid?

      # Assert
      expect(photoless_product).must_equal false
      expect(@product.errors.messages).must_include :photo_url
    end

    it "is invalid without stock" do
      # Arrange
      @product = products(:product1)
      @product.stock = nil

      #Act
      stockless_product = @product.valid?

      # Assert
      expect(stockless_product).must_equal false
      expect(@product.errors.messages).must_include :stock
    end

    it "is invalid with a stock that isn't numerical" do
      # Arrange
      @product = products(:product1)
      @product.stock = "stock"

      #Act
      stockless_product = @product.valid?

      # Assert
      expect(stockless_product).must_equal false
      expect(@product.errors.messages).must_include :stock
    end
  end
end
