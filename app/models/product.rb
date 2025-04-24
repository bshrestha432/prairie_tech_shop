class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_one_attached :image
  has_many :cart_items
  has_many :carts, through: :cart_items

  def self.ransackable_attributes(auth_object = nil)
    ["name", "description", "price", "stock_quantity", "category_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category"]
  end

  # Scope for products on sales
  scope :on_sale, -> { where(on_sale: true) }

  # Scope for products that were added within the last 3 days
  scope :new_arrivals, -> { where("created_at >= ?", 3.days.ago) }
end