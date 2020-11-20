require "test_helper"

describe MerchantsController do
  describe "index" do
    it "responds with success when there are many users saved" do
      # Arrange
      Merchant.create(username: "test", email: "test@test.com")
      # Act
      get merchants_path
      # Assert
      must_respond_with :success
    end

    it "responds with success when there are no merchants saved" do
      # Act
      get merchants_path
      # Assert
      must_respond_with :success
    end
  end

  describe "show" do
    # Arrange
    before do
      Merchant.create(username: "test", email: "test@test.com")
    end
    it "responds with success when showing an existing valid merchant" do
      # Arrange
      id = Merchant.find_by(username:"test")[:id]

      # Act
      get merchant_path(id)

      # Assert
      must_respond_with :success

    end

    it "responds with a redirect to the merchants page with an invalid id" do
      # Act
      get merchant_path(-1)
      # Assert
      must_redirect_to merchants_path
    end
  end

  describe "session functions " do
    # holding off until OAuth is implemented to add these
    describe "create" do
      # needs OAuth
    end
    describe "destroy" do
      # needs OAuth
    end
    # the following functions require login
    describe "dashboard" do

    end
    describe "edit" do

    end
    describe "update" do

    end
  end
end
