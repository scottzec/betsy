class RelateOrderItemToOrder < ActiveRecord::Migration[6.0]
  def change
    remove_column :orderitems, :order_id
    add_reference :orderitems, :order, index: true
  end
end
