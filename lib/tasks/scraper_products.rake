namespace :scrape do
  desc "Scrape products and categories from a third-party website"
  task :products => :environment do
    require 'nokogiri'
    require 'open-uri'
    require 'json'  # To parse JSON data

    # Define the URL of the API endpoint for products
    url = "https://fakestoreapi.com/products"  # Use the actual URL of the API

    # Open the URL and read the JSON response
    begin
      response = URI.open(url).read
    rescue OpenURI::HTTPError => e
      puts "Failed to retrieve data from the URL: #{e.message}"
      return
    end

    # Parse the JSON response
    products = JSON.parse(response)

    # Create categories and products based on the fetched data
    products.each do |product_data|
      # If category does not exist, create it
      category_name = product_data['category']
      category = Category.find_or_create_by!(name: category_name)

      # Create the product
      Product.create!(
        name: product_data['title'],
        description: product_data['description'],
        price: product_data['price'],
        stock_quantity: rand(1..100),  # Random stock quantity for now
        category: category
      )
    end

    puts "Products and categories have been scraped and added to the database."
  end
end
