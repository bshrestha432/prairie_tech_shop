class Product < ApplicationRecord
  belongs_to :category

  def self.ransackable_attributes(auth_object = nil)
    ["name", "description", "price", "stock_quantity", "category_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category"]
  end
end
