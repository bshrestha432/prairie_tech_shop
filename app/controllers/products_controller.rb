class ProductsController < ApplicationController
  before_action :authenticate_user!

  # Display all products (with category filter and pagination)
  def index

     # Apply search filter using ransack
     @search = Product.ransack(name_cont: params[:search])
     @products = @search.result(distinct: true).page(params[:page])
    # Check if a category is provided in the URL
    if params[:category].present?
      @category = Category.find_by(name: params[:category])

      if @category
        @products = @category.products.page(params[:page]).per(10)  # Pagination applied here
      else
        @products = Product.none.page(params[:page]).per(10)
      end
    else
      # If no category is provided, show all products with pagination
      @products = Product.all.page(params[:page]).per(10)  # Pagination applied here
    end

    # Filter by 'on sale' if the parameter is present
    if params[:filter] == 'on_sale'
      @products = @products.on_sale
    elsif params[:filter] == 'new_arrivals'
      @products = @products.new_arrivals
    end

    @categories = Category.all
  end

  # Show individual product details
  def show
    @product = Product.find(params[:id])
  end

  # Add product to cart
  def add_to_cart
    product = Product.find(params[:id])

    # Create a cart for the user if it doesn't exist
    current_user.create_cart unless current_user.cart

    # Add the product to the cart
    current_user.cart.add_product(product)

    # Flash message for success
    flash[:notice] = "#{product.name} added to cart."

    # Redirect to the product page or wherever you prefer
    redirect_to products_path
  end

  # Remove product from cart
  def remove_from_cart
    product = Product.find(params[:id])

    # Find the cart item and delete it
    current_user.cart.cart_items.find_by(product: product).destroy

    # Redirect to cart page
    redirect_to cart_path, notice: "#{product.name} removed from cart."
  end

  # Display cart contents
  def cart
    # Fetch the current user's cart
    @cart = current_user.cart
    @cart_items = @cart.cart_items # Fetch all items in the cart
  end

  # Update quantity of product in cart
  def update_quantity
    product = Product.find(params[:id])
    quantity = params[:quantity].to_i

    # Find the cart item and update its quantity
    cart_item = current_user.cart.cart_items.find_by(product: product)

    if cart_item
      # If quantity is greater than 0, update the cart item quantity
      if quantity > 0
        cart_item.update(quantity: quantity)
      else
        # If quantity is 0 or less, remove the product from cart
        cart_item.destroy
      end
    end

    # Flash message for updating cart
    flash[:notice] = "Cart updated."

    # Redirect to the cart page
    redirect_to cart_path
  end
end