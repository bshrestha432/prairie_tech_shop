ActiveAdmin.register AboutPage do
  permit_params :title, :content

  # Form for editing the about page contentss
  form do |f|
    f.inputs "About Page" do
      f.input :title
      f.input :content, as: :rich_text_area
    end
    f.actions
  end
end
