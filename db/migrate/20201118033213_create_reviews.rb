class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :review
      t.bigint :product_id

      t.timestamps
    end
  end
end
