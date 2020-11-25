require 'test_helper'

describe ProductsController do

  describe 'index' do
    it 'responds with success when there are existing products without login' do
      # Arrange
      # Ensure that there is at least one product saved
      product = products(:product1)
      product.save
      # Act
      get products_path
      # Assert
      must_respond_with :success
    end

    it 'responds with success when there are no drivers saved without login' do
      # Arrange
      # Ensure that there are zero products saved
      Product.delete_all
      # Act
      get products_path
      # Assert
      must_respond_with :success
    end
  end

  describe 'show' do
    it 'can get a valid product without login' do
      # Arrange that a product is saved
      product = products(:product1)
      product.save
      get product_path(product)

      # Assert
      must_respond_with :success
    end

    it 'will redirect for an invalid product without login' do
      # Act
      get product_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe 'when signed in' do
    before do
      perform_login(merchants(:test))
    end

    describe 'new' do
      it 'new product action responds with success' do
        # Act
        get new_merchant_product_path(merchants(:test))

        # Assert
        must_respond_with :success
      end
    end

    describe 'create' do
        before do
          @product =
            {
              product: {
              name: 'moss',
              description: 'squishy',
              price: 4,
              photo_url: 'url',
              stock: 3
            }
          }  
        end

        it 'can create a new trip' do
        # Act-Assert
        expect do
          post merchant_products_path(merchants(:test)), params: @product
        end.must_change 'Product.count', 1

        must_respond_with :redirect
        # product = Product.find_by(name: "moss")
        product = Product.last
        must_redirect_to product_path(product.id)
      end
    end

    describe "edit" do
      it "can get the edit page for an existing, valid product and responds with XXXX" do
        # Assert
        product = products(:product1)
        product.save

        # Act
        get edit_product_path(product)

        # Assert
        must_respond_with :success
      end

      it "will respond with 404 when attempting to edit a nonexistent product" do
        # Act
        get edit_product_path(-1)

        # Assert
        must_respond_with :missing
      end
    end


    describe "update" do
      before do
        @product =
            {
                product: {
                    name: 'ivy',
                    description: 'verdant green',
                    price: 5,
                    photo_url: 'url',
                    stock: 4
                }
            }
      end
      it "can update an existing task" do
        product = products(:product1)
        expect {
          patch product_path(product.id), params: @product
        }.wont_change "Product.count"

        must_redirect_to dashboard_path

        # Test that update happened:
        updated_product = Product.find_by(name: "ivy")
        expect(updated_product.price).must_equal 5
      end

      it "will redirect to the root page if given an invalid id" do
        # Act
        patch product_path(-1)

        # Assert
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end

    describe "destroy" do
      it "can destroy an existing product and redirects to the product index page" do
        product = products(:product1)
        product.save

        expect {
          delete product_path(product)
        }.must_differ 'Product.count', -1

        must_redirect_to products_path
      end
    end
  end
end