class HomeController < ApplicationController
  def index
    @homepage = Page.find_by(title: 'Home')  # Find the page with title 'Home'

    # If the Home page is missing, create a default one (optional fallback)
    if @homepage.nil?
      @homepage = Page.create!(title: 'Home', content: 'Content for the home page is missing. Please create one in the admin.')
    end

    # Fetch the products associated with this page based on product_ids
    if @homepage.product_ids.present?
      @products = Product.where(id: @homepage.product_ids)
    else
      @products = []  # If no products are associated with the Home page
    end
  end
end
