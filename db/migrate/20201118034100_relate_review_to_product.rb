class RelateReviewToProduct < ActiveRecord::Migration[6.0]
  def change
    remove_column :reviews, :product_id
    add_reference :reviews, :product, index: true
  end
end
