# Ensure admin user exists in development
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# Clear existing data to avoid duplication
Category.destroy_all
Product.destroy_all

# Create 4 categories
categories = ['Electronics', 'Home Appliances', 'Clothing', 'Sports']
categories.each do |category_name|
  Category.create!(name: category_name)
end

# Create 100 products and assign them randomly to categories
100.times do
  # Generate random product data using Faker
  product_name = Faker::Commerce.product_name
  product_description = Faker::Lorem.sentence(word_count: 15)
  product_price = Faker::Commerce.price(range: 100..1000)
  product_stock_quantity = Faker::Number.between(from: 1, to: 100)
  product_category = Category.order("RANDOM()").first  # Assign a random category

  # Create the product
  Product.create!(
    name: product_name,
    description: product_description,
    price: product_price,
    stock_quantity: product_stock_quantity,
    category: product_category
  )
end

puts "Seeded #{Category.count} categories and #{Product.count} products."
