ActiveAdmin.register Page do
  permit_params :title, :content

  # Define the columns to display in the admin index page
  index do
    selectable_column
    id_column
    column :title
    column :content
    actions
  end

  # Define the form fields for creating or editing a pages
  form do |f|
    f.inputs do
      f.input :title
      f.input :content, as: :rich_text_area # Optionally use a rich text editor for content
      f.input :product_ids, as: :select, collection: Product.all.collect { |p| [p.name, p.id] }, multiple: true
    end
    f.actions
  end
end
