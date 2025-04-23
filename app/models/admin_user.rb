class AdminUser < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable
  # If you are using ActiveAdmin, add any other necessary code here

  # Explicitly define searchable attributes
  def self.ransackable_attributes(auth_object = nil)
    ["email", "username", "created_at", "updated_at"]
  end

  # If you need to make associations searchable, define them here as well
  def self.ransackable_associations(auth_object = nil)
    ["roles"]  # Add any associations that you want to make searchable
  end
end
