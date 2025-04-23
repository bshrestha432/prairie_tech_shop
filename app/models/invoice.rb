class Invoice < ApplicationRecord
  belongs_to :user
  has_many :order_items

  validates :total_amount, :status, presence: true
end
