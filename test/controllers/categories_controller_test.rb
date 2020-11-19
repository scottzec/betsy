require "test_helper"

describe CategoriesController do
  describe "index" do
    it "responds with success when there are many categories saved" do
      # Arrange
      Category.create(name: "test")
      # Act
      get merchants_path
      # Assert
      must_respond_with :success
    end

    it "responds with success when there are no categories saved" do
      # Arrange

      # Act
      get merchants_path
      # Assert
      must_respond_with :success
    end
  end

  describe "show" do
    # Arrange
    before do
      Category.create(name: "test")
    end
    it "responds with success when showing an existing valid category" do
      # Arrange
      id = Category.find_by(name:"test")[:id]

      # Act
      get category_path(id)

      # Assert
      must_respond_with :success
    end

    it "responds with a redirect (returns success) to the categories page with an invalid id" do
      # Act
      get category_path(-1)

      # Assert
      must_redirect_to categories_path

    end
  end

  describe "session functions" do
    before do
      @merchant1 = Merchant.create(username: "m1", email: "m1@email.com")
    end
    # the following functions require login
    describe "new" do
      # needs OAuth
      it "prevents non signed in users from visiting the page to make a new category" do
        get new_category_path

        must_redirect_to categories_path
      end
      it "allows signed in users to visit the page to make a new category" do
        @login_data = {merchant: {username: @merchant1.username, email:@merchant1.email} }
        post login_path(@login_data) # REFACTOR

        get new_category_path

        must_respond_with :success
      end
    end
    describe "create" do
      before do
        @login_data = {merchant: {username: @merchant1.username, email:@merchant1.email} }
        post login_path(@login_data) # REFACTOR
      end
      # needs OAuth
      it "creates a new valid category" do
        @cat = {category: {name: "test"} }

        expect{
          post categories_path, params: @cat
        }.must_change "Category.count", 1

        must_redirect_to dashboard_path

      end
      # add after validations
      # it "returns a bad request and renders the new page if category is blank" do
      #   @cat = {category: {name: "test"} }
      #
      #   expect{
      #     post categories_path, params: @cat
      #   }.wont_change "Category.count"
      #
      #   must_respond_with :bad_request
      # end
    end
  end
end
