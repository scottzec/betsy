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

  describe "login/out functions " do
    # holding off until OAuth is implemented to add these
    describe "create" do
      # needs OAuth
    end
    describe "destroy" do
      # needs OAuth
    end
  end
  describe "active session only functions" do
    before do
      @merchant1 = Merchant.create(username: "m1", email: "m1@email.com")
      @merchant2 = Merchant.create(username: "m2", email: "m2@email.com")
      @login_data = {merchant: {username: @merchant1.username, email:@merchant1.email} }
    end
    # the following functions require login
    describe "dashboard" do
      it "prevents non logged in users from accessing dashboard" do
        get dashboard_path

        must_redirect_to root_path

      end
      it "allows logged in users to access dashboard" do
        post login_path(@login_data)
        get dashboard_path

        # this is a little redundant, but one thing to note is that the route is written so that
        # this only applies to the CURRENT user -- you can never access another merchant's dashboard but your
        # own
        expect(Merchant.find_by(id: session[:user_id])).must_equal @merchant1

        must_respond_with :success
      end
    end
    describe "edit" do
      it "blocks invalid merchants" do
        post login_path(@login_data)

        get edit_merchant_path(-1)

        must_redirect_to dashboard_path

      end
      it "prevents a logged in merchant from accessing another merchant's edit page" do
        post login_path(@login_data)

        get edit_merchant_path(@merchant2.id)

        must_redirect_to dashboard_path
      end
      it "permits access for a logged in user to access their edit page" do
        post login_path(@login_data)

        get edit_merchant_path(@merchant1.id)

        must_respond_with :success
      end
      it "blocks non-logged in users" do
        get edit_merchant_path(@merchant1.id)

        must_redirect_to merchants_path
      end
    end

    describe "update" do

    end
  end
end
