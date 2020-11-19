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
    # the following functions require login
    describe "new" do
      # needs OAuth
    end
    describe "create" do
      # needs OAuth
    end
  end
end
