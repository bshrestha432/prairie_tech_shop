class Category < ApplicationRecord
  has_many :products

  # Explicitly list searchable attributes
  def self.ransackable_attributes(auth_object = nil)
    ["name", "description", "id", "created_at", "updated_at"]
  end

  # Explicitly list searchable associations
  def self.ransackable_associations(auth_object = nil)
    ["products"]  # Allows search for associated products
  end
end
