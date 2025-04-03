ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity, :category_id, :image_url

  # Define the columns to display in the admin index page
  index do
    selectable_column
    id_column
    column :name
    column :price
    column :stock_quantity
    column :category
    actions
  end

  # Define the form fields for creating or editing products
  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :category, as: :select, collection: Category.all.collect { |c| [c.name, c.id] }, include_blank: false
      f.input :image_url
    end
    f.actions
  end

  # Specify the filters you want to use
  filter :name
  filter :description
  filter :price
  filter :stock_quantity
  filter :category
end
