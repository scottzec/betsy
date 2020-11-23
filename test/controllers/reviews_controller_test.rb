require "test_helper"
# REFACTOR /ALL/ FOR OAUTH
describe ReviewsController do
  describe "when signed in" do
    before do
      perform_login(merchants(:test))
    end
    describe "new" do
      it "allows a signed-in user that is not the merchant selling the product to go to the form to leave a review" do
        # Act
        get new_product_review_path(products(:product3).id)

        # Assert
        must_respond_with :success
      end
      it "forbids the merchant selling the product to leave a review for it and redirects to the product page" do
        # Act
        get new_product_review_path(products(:product1).id)

        # Assert
        must_redirect_to product_path(products(:product1).id)
      end
    end

    describe "create" do
      before do
        @review = {review: {rating: 5, review: "this should work"} }
      end
      it "lets a merchant review another product" do
        expect{
          post product_reviews_path(products(:product3).id), params: @review
        }.must_change "Review.count", 1

        must_redirect_to product_path(products(:product3).id)
      end
      it "blocks a merchant from reviewing their own product" do
        # # yes, even if they try to do it through postman
        expect{
          post product_reviews_path(products(:product1).id), params: @review
        }.wont_change "Review.count"

        must_redirect_to product_path(products(:product1).id)
      end
    end
  end

  describe "when signed out" do
    describe "new" do
      it "allows a non signed-in user that is not the merchant selling the product to go to the form leave a review" do
        # Act
        get new_product_review_path(products(:product1).id)

        # Assert
        must_respond_with :success
      end
      it "redirects to products page if product doesn't exist" do
        get new_product_review_path(-1)

        must_redirect_to root_path
      end
    end

    describe "create" do
      before do
        @review = {review: {rating: 5, review: "this should work"} }
      end
      it "creates a new review" do

        expect{
          post product_reviews_path(products(:product1).id), params: @review
        }.must_change "Review.count", 1

        must_redirect_to product_path(products(:product1).id)
        new_review = Review.find_by(product_id: products(:product1).id, review: "this should work")
        expect(new_review.rating).must_equal @review[:review][:rating]
      end
      it "doesn't create a review for a product that doesn't exist" do
        expect{
          post product_reviews_path(-1), params: @review
        }.wont_change "Review.count"

        must_redirect_to root_path
      end
      it "forbids the saving of an invalid review" do
        @invalid_review = {review: {product_id: products(:product1).id,
                                    rating: -1,
                                    review: "invalid rating"} }
        expect{
          post product_reviews_path(products(:product1).id), params: @invalid_review
        }.wont_change "Review.count"

        must_respond_with :bad_request
      end
    end
  end
end
