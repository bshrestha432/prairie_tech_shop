ActiveAdmin.register Category do
  permit_params :name, :description, product_ids: []  # Allow the selection of multiple products

  # Define the columns to display in the admin index pages
  index do
    selectable_column
    id_column
    column :name
    column :description
    column "Products" do |category|
      category.products.map(&:name).join(', ')  # Display product names associated with the category
    end
    actions
  end

  # Search filters for the index page
  filter :name
  filter :description
  filter :products_name, as: :string, label: 'Product Name'  # Allows search for associated product names

  # Form for creating/editing categories
  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :products, as: :select, collection: Product.all.collect { |p| [p.name, p.id] }, multiple: true  # Multi-select for products
    end
    f.actions
  end

  # Controller for search functionality
  controller do
    def scoped_collection
      # This allows filtering categories based on products
      super.includes(:products)
    end
  end
end
