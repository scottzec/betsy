require "test_helper"

describe OrderitemsController do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end
  #

  describe "show" do
    it "responds with success when showing an existing valid orderitem" do
      oi1 = orderitems(:shipped1)
      get orderitem_path(oi1.id)

      must_respond_with :success
    end

    it "responds with redirect with an invalid orderitem id" do
      get orderitem_path(-1)

      must_respond_with :redirect
      must_redirect_to root_path
    end

  end



end

