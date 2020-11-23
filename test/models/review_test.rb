require "test_helper"

describe Review do
  it "can be instantiated" do
    expect(reviews(:review1).valid?).must_equal true
  end
  it "will have the required fields" do
    rev = Review.first
    expect(rev).must_respond_to :rating
    expect(rev).must_respond_to :review
  end

  describe "relationships" do
    it "can belong to a product" do
      review = products(:product1).reviews.find_by(id: reviews(:review1).id)

      expect(review).must_equal reviews(:review1)
    end
    it "can belong to a product along with another review" do
      prod = reviews(:review1).product
      prod2 = reviews(:review2).product

      expect(prod).must_equal prod2
    end
    it "can get information about a product through its relation" do
      product = reviews(:review1).product

      expect(product.name).must_equal products(:product1).name
      expect(product.description).must_equal products(:product1).description
      expect(product.price).must_be_close_to products(:product1).price
      expect(product.stock).must_equal products(:product1).stock
      expect(product.photo_url).must_equal products(:product1).photo_url
      expect(product.merchant_id).must_equal products(:product1).merchant_id
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
      no_product = Review.new(rating: 1)

      expect(no_product.valid?).must_equal false
      expect(no_product.errors.messages[:product]).must_include "must exist"
    end
  end
  # no custom methods
end
