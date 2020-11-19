require "test_helper"
# REFACTOR /ALL/ FOR OAUTH
describe ReviewsController do
  before do
    @merchant1 = Merchant.create(username: "m1", email: "m1@email.com")
    @merchant2 = Merchant.create(username: "m2", email: "m2@email.com")
    @product = Product.create(name: "review me", description: "an item", price: 1.00, photo_url:"/images/defaultimage.png", stock: 5, merchant_id: @merchant1.id)
  end
  describe "new" do
    it "allows a non signed-in user that is not the merchant selling the product to go to the form leave a review" do
      # Act
      get new_product_review_path(@product.id)

      # Assert
      must_respond_with :success
    end
    it "allows a signed-in user that is not the merchant selling the product to go to the form to leave a review" do
      @login_data = {merchant: {username: @merchant2.username, email:@merchant2.email} }
      post login_path(@login_data) # REFACTOR
      # Act
      get new_product_review_path(@product.id)

      # Assert
      must_respond_with :success
    end
    it "forbids the merchant selling the product to leave a review for it and redirects to the product page" do
      @login_data = {merchant: {username: @merchant1.username, email: @merchant1.email} }
      post login_path(@login_data) # REFACTOR

      # Act
      get new_product_review_path(@product.id)

      # Assert
      must_redirect_to product_path(@product.id)
    end
    it "redirects to products page if product doesn't exist" do
      get new_product_review_path(-1)

      must_redirect_to root_path
    end
  end
  describe "create" do
    # right now, the views only permit creation of reviews through the new page
    # this by default already prevents a signed in user from accessing the
    it "creates a new review" do
      @review = {review: {rating: 5, review: "this should work"} }
      expect{
        post product_reviews_path(@product.id), params: @review
      }.must_change "Review.count", 1

      must_redirect_to product_path(@product.id)
    end
    # when validations can be implemented
    # it "forbids the saving of an invalid review"" do
    #   @invalid_review = {review: {product_id: @product.id, rating: -1, review: "invalid rating"} }
    #   expect{
    #     post product_reviews_path(review_params)
    #   }.wont_change "Review.count"
    #
    #   must_respond_with :bad_request
    # end
  end
end
