class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:index]  # Ensure user is logged in

  def index
    @homepage = Page.find_by(title: 'Home')  # Find the page with title 'Home'

    # If the Home page is missing, create a default one (optional fallback)
    if @homepage.nil?
      @homepage = Page.create!(title: 'Home', content: 'Content for the home page is missing. Please create one in the admin.')
    end


    # Filter for on_sale and new_arrivals
    @on_sale_products = Product.on_sale
    @new_arrival_products = Product.new_arrivals

    # Initialize product search scope
    @products = Product.all

    # Search functionality
    if params[:search].present?
      # Filter products by keyword in the title or description
      @products = @products.where("name LIKE ?", "%#{params[:search]}%")

    end

    # Filter by category if selected
    if params[:category].present?
      @category = Category.find(params[:category])
      @products = @products.where(category_id: @category.id)
    end

    # Apply pagination to the filtered products
    @products = @products.page(params[:page]).per(10)

    # Fetch all categories for the category dropdown (if needed in the view)
    @categories = Category.all

    # Load the cart for the logged-in user
    @cart = current_user.cart if user_signed_in?
    @products_in_cart = @cart ? @cart.products : []
  end
end
