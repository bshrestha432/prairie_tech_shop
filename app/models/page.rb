class Page < ApplicationRecord
  # Manually handle the serialization of product_ids as an array
  def product_ids
    read_attribute(:product_ids).split(',').map(&:to_i) if read_attribute(:product_ids).present?
  end

  def product_ids=(value)
    write_attribute(:product_ids, value.join(',')) if value.present?
  end
end
