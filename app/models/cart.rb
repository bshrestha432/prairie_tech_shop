class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def add_product(product)
    Rails.logger.debug "Adding product to cart: #{product.inspect}"
    item = cart_items.find_by(product: product)

    if item
      item.increment(:quantity, 1)
    else
      cart_items.create(product: product, quantity: 1)
    end
    save
  end

  def remove_product(product)
    cart_items.find_by(product: product).destroy
  end

  def update_quantity(product, quantity)
    cart_item = cart_items.find_by(product: product)
    cart_item.update(quantity: quantity) if cart_item
  end
end
