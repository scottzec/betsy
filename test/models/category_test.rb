require "test_helper"

describe Category do
  before do
    @merchant = Merchant.create(username: "test", email: "test@test.com")
    @category = Category.create(name: "test")
    @category2 = Category.create(name: "test2")
    @product = Product.create(name: "product",
                              description: "the product",
                              price: 10.00,
                              photo_url: "/images/defaultimage.jpg",
                              stock: 10,
                              merchant_id: @merchant.id)
  end

  it "can be instantiated" do
    expect(@category.valid?).must_equal true
  end
  it "will have the required fields" do
    cat = Category.first
    expect(cat).must_respond_to :name
  end

  describe "relationships" do
    it "can belong to a product" do
      @product.categories << @category
      category = @product.categories.find_by(id: @category.id)

      expect(category).must_equal @category
    end
    it "can belong to a product along with another category" do
      @product.categories << @category
      @product.categories << @category2

      product = @category.products.find_by(id: @product.id)
      product2 = @category2.products.find_by(id: @product.id)

      expect(product).must_equal product2
    end
    it "can get information about a product through its relation" do
      @product.categories << @category
      product = @category.products.find_by(id: @product.id)

      expect(product.name).must_equal @product.name
      expect(product.description).must_equal @product.description
      expect(product.price).must_be_close_to @product.price
      expect(product.stock).must_equal @product.stock
      expect(product.photo_url).must_equal @product.photo_url
      expect(product.merchant_id).must_equal @product.merchant_id
      # should expect all products to be tied to a merchant
    end
  end

  describe "validations" do
    it "must have a name" do
      no_name = Category.new(name: nil)
      expect(no_name.valid?).must_equal false
      expect(no_name.errors.messages[:name]).must_include "can't be blank"
    end
    # can be instantiated test creates a category with no products and is confirmed valid.
  end
  # no custom methods
end
