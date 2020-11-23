require "test_helper"

describe Category do
  it "can be instantiated" do
    expect(categories(:category1).valid?).must_equal true
  end
  it "will have the required fields" do
    cat = Category.first
    expect(cat).must_respond_to :name
  end

  describe "relationships" do
    it "can belong to a product" do
      category = products(:product1).categories.find_by(id: categories(:category1).id)

      expect(category).must_equal categories(:category1)
    end
    it "can belong to a product along with another category" do
      product = categories(:category2).products.find_by(id: products(:product1))
      product2 = categories(:category3).products.find_by(id: products(:product1))

      expect(product).must_equal product2
    end
    it "can get information about a product through its relation" do
      product = categories(:category1).products.find_by(id: products(:product1).id)

      expect(product.name).must_equal products(:product1).name
      expect(product.description).must_equal products(:product1).description
      expect(product.price).must_be_close_to products(:product1).price
      expect(product.stock).must_equal products(:product1).stock
      expect(product.photo_url).must_equal products(:product1).photo_url
      expect(product.merchant_id).must_equal products(:product1).merchant_id
      # should expect all products to be tied to a merchant
    end
  end

  describe "validations" do
    it "must have a name" do
      no_name = Category.new(name: nil)
      expect(no_name.valid?).must_equal false
      expect(no_name.errors.messages[:name]).must_include "can't be blank"
    end
    # can be instantiated test creates a category with no products and is confirmed valid.
  end
  # no custom methods
end
