ActiveAdmin.register Category do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment

  permit_params :name, :description

  index do
    selectable_column
    id_column
    column :name
    column :description
    actions
  end
end
ActiveAdmin.register Category do
  permit_params :name, :description

  # Define the columns to display in the admin index page
  index do
    selectable_column
    id_column
    column :name
    column :description
    actions
  end

  # Define the form fields for creating or editing a category
  form do |f|
    f.inputs do
      f.input :name
      f.input :description
    end
    f.actions
  end
end
