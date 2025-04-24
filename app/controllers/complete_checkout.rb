class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:index, :complete_checkout]

  def complete_checkout
    # Set up Stripe with your secret key
    Stripe.api_key = Rails.application.credentials.stripe[:secret_key]

    # Retrieve the cart and calculate the invoice
    @cart = current_user.cart
    @invoice = calculate_invoice(@cart)  # Make sure this method calculates the total invoice

    # Retrieve payment method ID from the form (you may have this in params)
    payment_method_id = params[:payment_method_id]

    # Create a new order in the database
    @order = Order.create!(user: current_user, total_price: @invoice[:total_price])

    # Example: Charge the payment using Stripe (You need to have Stripe set up)
    begin
      charge = Stripe::PaymentIntent.create({
        amount: (@invoice[:total_price] * 100).to_i,  # Amount in cents
        currency: 'usd',
        payment_method: payment_method_id,
        confirm: true
      })

      # If payment is successful, associate the order with the cart items
      @cart.cart_items.each do |item|
        @order.order_items.create!(product: item.product, quantity: item.quantity, price: item.product.price)
      end

      # Clear the cart after successful payment
      @cart.cart_items.destroy_all

      # Redirect to order confirmation page with success message
      redirect_to order_confirmation_path, notice: 'Your order has been successfully placed!'

    rescue Stripe::CardError => e
      flash[:alert] = "Payment failed: #{e.message}"
      redirect_to checkout_path
    end
  end
end
