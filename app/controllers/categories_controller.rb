# app/controllers/categories_controller.rb

class CategoriesController < ApplicationController
  def index
    # Display all categories
    @categories = Category.all
  end

  def show
    # Find the category by its ID
    @category = Category.find(params[:id])

    # Fetch all products belonging to this category
    @products = @category.products
  end
end
