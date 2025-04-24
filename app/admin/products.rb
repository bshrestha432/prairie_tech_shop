ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity, :category_id, :image

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

  # Define the form fields for creating or editing product
  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :category, as: :select, collection: Category.all.collect { |c| [c.name, c.id] }, include_blank: false
      f.input :image, as: :file
    end
    f.actions
  end

  # Specify the filters you want to use
  filter :name
  filter :description
  filter :price
  filter :stock_quantity
  filter :category

  # Customizing the batch action to handle dependent records
  batch_action :destroy, confirm: "Are you sure you want to delete these products?" do |ids|
    # Find products by their IDs and delete them along with their related cart_items and order_items
    Product.find(ids).each do |product|
      # Destroy related cart_items and order_items
      product.cart_items.destroy_all
      product.order_items.destroy_all
      product.destroy
    end
    redirect_to collection_path, notice: "Selected products and their related items have been deleted."
  end

  # Handle the destroy action to ensure related records are cleaned up before product deletion
  controller do
    def destroy
      @product = Product.find(params[:id])

      # Destroy related cart_items and order_items before destroying the product
      @product.cart_items.destroy_all
      @product.order_items.destroy_all
      @product.destroy

      redirect_to admin_products_path, notice: "Product and related items deleted successfully."
    end
  end
end
