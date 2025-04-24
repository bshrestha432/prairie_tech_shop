class Page < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "title", "product_ids", "updated_at"]
  end

  # Manually handles the serialization of product_ids as an array
  def product_ids
    read_attribute(:product_ids).split(',').map(&:to_i) if read_attribute(:product_ids).present?
  end

  def product_ids=(value)
    write_attribute(:product_ids, value.join(',')) if value.present?
  end
end
