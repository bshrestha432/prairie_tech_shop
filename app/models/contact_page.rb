class ContactPage < ApplicationRecord
  has_rich_text :content
  # Define attribute that are searchable with Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["title", "content"]
  end
end
