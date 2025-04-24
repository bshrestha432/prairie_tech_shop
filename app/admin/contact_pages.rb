ActiveAdmin.register ContactPage do
  permit_params :title, :content

  # Define the form for editing the contact pages
  form do |f|
    f.inputs "Contact Page" do
      f.input :title
      f.input :content, as: :rich_text_area
    end
    f.actions
  end
end
