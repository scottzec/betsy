require "test_helper"

describe CategoriesController do
  describe "logged out" do
    describe "index" do
      it "responds with success when there are many categories saved" do
        get categories_path
        # Assert
        must_respond_with :success
      end

      it "responds with success when there are no categories saved" do
        # Arrange
        Category.delete_all
        # Act
        get categories_path
        # Assert
        must_respond_with :success
      end
    end

    describe "show" do
      it "responds with success when showing an existing valid category" do
        # Act
        get category_path(categories(:category1).id)

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

    describe "new" do
      it "prevents non signed in users from visiting the page to make a new category" do
        get new_category_path

        must_redirect_to root_path
      end
    end

    describe "create" do
      it "blocks signed out merchants from making categories" do
        @cat = {category: {name: "test"} }

        expect{
          post categories_path, params: @cat
        }.wont_change "Category.count"

        must_redirect_to root_path
      end
    end
  end

  describe "logged in" do
    before do
      perform_login(merchants(:test))
    end
    describe "new" do
      it "allows signed in users to visit the page to make a new category" do
        get new_category_path

        must_respond_with :success
      end
    end
    describe "create" do
      # needs OAuth
      it "creates a new valid category" do
        @cat = {category: {name: "test"} }

        expect{
          post categories_path, params: @cat
        }.must_change "Category.count", 1

        must_redirect_to dashboard_path

      end

      it "returns a bad request and renders the new page if category is blank" do
         @cat = {category: {name: nil} }

         expect{
           post categories_path, params: @cat
         }.wont_change "Category.count"

         must_respond_with :bad_request
      end
    end
  end
end
