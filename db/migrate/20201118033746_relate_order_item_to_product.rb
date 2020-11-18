class RelateOrderItemToProduct < ActiveRecord::Migration[6.0]
  def change
    remove_column :orderitems, :product_id
    add_reference :orderitems, :product, index: true
  end
end
