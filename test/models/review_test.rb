require "test_helper"

describe Review do
  before do
    @merchant = Merchant.create(username: "test", email: "test@test.com")
    @product = Product.create(name: "product",
                              description: "the product",
                              price: 10.00,
                              photo_url: "/images/defaultimage.jpg",
                              stock: 10,
                              merchant_id: @merchant.id)
    @review = Review.create(rating: 5, review: "cool", product_id: @product.id)
    @review2 = Review.create(rating: 5, review: "cooler", product_id: @product.id)
  end
  it "can be instantiated" do
    expect(@review.valid?).must_equal true
  end
  it "will have the required fields" do
    rev = Review.first
    expect(rev).must_respond_to :rating
    expect(rev).must_respond_to :review
  end

  describe "relationships" do
    it "can belong to a product" do
      review = @product.reviews.find_by(id: @review.id)

      expect(review).must_equal @review
    end
    it "can belong to a product along with another review" do
      prod = @review.product
      prod2 = @review2.product

      expect(prod).must_equal prod2
    end
    it "can get information about a product through its relation" do
      product = @review.product

      expect(product.name).must_equal @product.name
      expect(product.description).must_equal @product.description
      expect(product.price).must_be_close_to @product.price
      expect(product.stock).must_equal @product.stock
      expect(product.photo_url).must_equal @product.photo_url
      expect(product.merchant_id).must_equal @product.merchant_id
    end
  end

  describe "validations" do
    it "must have a rating" do
      no_rating = Review.new(rating: nil)
      expect(no_rating.valid?).must_equal false
      expect(no_rating.errors.messages[:rating]).must_include "can't be blank"
    end

    it "must have a numerical rating" do
      # not really snake case but ruby docs confirms NaN exists
      rating_NaN = Review.new(rating: true) # confirmed that "truthiness" wont apply here
      expect(rating_NaN.valid?).must_equal false
      expect(rating_NaN.errors.messages[:rating]).must_include "is not a number"
    end

    it "must have an integer rating" do
      rating_float = Review.new(rating: 4.4)

      expect(rating_float.valid?).must_equal false
      expect(rating_float.errors.messages[:rating]).must_include "must be an integer"
    end

    it "must have a rating between 1 and 5, inclusive" do
      rating_below = Review.new(rating: 0)
      rating_above = Review.new(rating: 6)

      expect(rating_below.valid?).must_equal false
      expect(rating_above.valid?).must_equal false

      expect(rating_below.errors.messages[:rating]).must_include "must be greater than or equal to 1"
      expect(rating_above.errors.messages[:rating]).must_include "must be less than or equal to 5"
    end

    it "must belong to a product" do

    end
  end
  # no custom methods
end
