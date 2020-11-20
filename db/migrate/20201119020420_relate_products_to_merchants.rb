class RelateProductsToMerchants < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :merchant_id
    add_reference :products, :merchant, index: true
  end
end
