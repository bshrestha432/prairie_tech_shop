class CustomersController < ApplicationController
  before_action :authenticate_user!

  def edit
    @customer = current_user.customer
  end

  def update
    @customer = current_user.customer
    if @customer.update(customer_params)
      redirect_to checkout_path, notice: "Address updated successfully!"
    else
      render :edit
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:address)  # You can add other fields like city, postal_code, etc.
  end
end
