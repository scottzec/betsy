class CreateOrderitems < ActiveRecord::Migration[6.0]
  def change
    create_table :orderitems do |t|
      t.integer :quantity
      t.bigint :order_id
      t.bigint :product_id

      t.timestamps
    end
  end
end
