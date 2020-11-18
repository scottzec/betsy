class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :name
      t.string :email
      t.string :address
      t.string :credit_card_number
      t.string :cvv
      t.string :expiration_date
      t.string :zip_code
      t.float :total

      t.timestamps
    end
  end
end
