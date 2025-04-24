class User < ApplicationRecord
  belongs_to :province
  has_one :customer, dependent: :destroy
  has_one :cart, dependent: :destroy

  # Devise modules for authentications
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  # Validations for username and address fields
  validates :username, presence: true, uniqueness: true

  # Ensure a customer is created automatically when a user is created
  after_initialize :build_customer, if: :new_record?

  # Method to create a new cart for the user if not already created
  def create_cart
    build_cart.save
  end

  # Ensure customer record is created for the user (if not already created)
  def create_customer
    build_customer.save if customer.nil?  # Create customer if not already created
  end
end
