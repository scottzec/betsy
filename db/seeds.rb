# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'
MERCHANT_FILE = Rails.root.join('db', 'merchants-seeds.csv')
puts "Loading raw work data from #{MERCHANT_FILE}"
merchant_failures = []
CSV.foreach(MERCHANT_FILE, :headers => true) do |row|
  merchant = Merchant.new
  merchant.username = row['username']
  merchant.email = row['email']
  successful = merchant.save
  if !successful
    merchant_failures << merchant
    puts "Failed to save merchant: #{merchant.inspect}"
  else
    puts "Created merchant: #{merchant.inspect}"
  end
end
puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchants failed to save"

PRODUCT_FILE = Rails.root.join('db', 'products-seeds.csv')
puts "Loading raw work data from #{PRODUCT_FILE}"
product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.name = row['name']
  product.description = row['description']
  product.price = row['price']
  product.photo_url = row['photo_url']
  product.stock = row['stock']
  product.merchant_id = row['merchant_id']
  successful = product.save
  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end
end
puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"

ORDER_FILE = Rails.root.join('db', 'orders-seeds.csv')
puts "Loading raw work data from #{ORDER_FILE}"
order_failures = []
CSV.foreach(ORDER_FILE, :headers => true) do |row|
  order = Order.new
  order.status = row['status']
  order.name = row['name']
  order.email = row['email']
  order.address = row['address']
  order.credit_card_number = row['credit_card_number']
  order.cvv = row['cvv']
  order.expiration_date = row['expiration_date']
  order.zip_code = row['zip_code']
  order.total = row['total']

  successful = order.save
  if !successful
    order_failures << order
    puts "Failed to save order: #{order.inspect}"
  else
    puts "Created order: #{order.inspect}"
  end
end
puts "Added #{Order.count} order records"
puts "#{order_failures.length} orders failed to save"

ORDER_ITEMS_FILE = Rails.root.join('db', 'order-item-seeds.csv')
puts "Loading raw work data from #{ORDER_ITEMS_FILE}"
order_item_failures = []
CSV.foreach(ORDER_ITEMS_FILE, :headers => true) do |row|
  order_item = Orderitem.new
  order_item.quantity = row['quantity']
  order_item.order_id = row['order_id']
  order_item.product_id = row['product_id']
  successful = order_item.save
  if !successful
    order_item_failures << order_item
    puts "Failed to save product: #{order_item.inspect}"
  else
    puts "Created product: #{order_item.inspect}"
  end
end
puts "Added #{Orderitem.count} order item records"
puts "#{order_item_failures.length} order items failed to save"

puts "Manually resetting PK sequence on each table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end
puts "done"