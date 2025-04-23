class CheckoutController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:complete_checkout]

  # Display the checkout page
  def show
    @cart = current_user.cart
    @invoice = calculate_invoice(@cart)
    @customer = current_user.customer
    @stripe_publishable_key = Rails.application.credentials.stripe[:publishable_key]  # Access Stripe Publishable Key from credentials.yml.enc

    # If the customer doesn't have an address, they should be prompted to enter it
    if @customer && @customer.address.nil?
      flash[:notice] = "Please provide your address before completing the checkout."
      redirect_to edit_user_registration_path  # Redirect to address edit page
    end
  end

  # Handle checkout and create an order from the current cart
  def complete_checkout
    # Set up Stripe with your secret key
    Stripe.api_key = Rails.application.credentials.stripe[:secret_key]

    @cart = current_user.cart
    @invoice = calculate_invoice(@cart)

    payment_method_id = params[:payment_method_id]

    begin
      payment_intent = Stripe::PaymentIntent.create({
        amount: (@invoice[:total_price] * 100).to_i,  # Amount in cents
        currency: 'usd',
        payment_method: payment_method_id,  # Payment method ID received from Stripe Elements on the frontend
        confirm: true,
        payment_method_types: ['card'],
      })

      if payment_intent.status == 'succeeded'
        # Create invoice record
        @invoice = Invoice.create!(
          user: current_user,
          total_amount: @invoice[:total_price],
          status: 'paid',
          payment_method_id: payment_intent.id
        )

        # Create order record and associate cart items
        @order = current_user.orders.create(
          total_price: @invoice.total_amount,
          tax: @invoice.taxes,
          payment_status: 'paid',
          invoice: @invoice  # Associate the order with the invoice
        )

        @cart.cart_items.each do |cart_item|
          @order.order_items.create(
            product: cart_item.product,
            quantity: cart_item.quantity,
            price: cart_item.product.price
          )
        end

        # Clear the cart after payment
        current_user.cart.cart_items.destroy_all

        # Return JSON response with order ID for redirect
        render json: { order_id: @order.id }, status: :ok
      else
        render json: { error: 'Payment failed. Please try again.' }, status: :unprocessable_entity
      end
    rescue Stripe::StripeError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  # Calculate the total invoice with taxes
  def calculate_invoice(cart)
    total_price = cart.cart_items.sum { |item| item.product.price * item.quantity }
    taxes = calculate_taxes(cart)
    { total_price: total_price + taxes, taxes: taxes }
  end

  # Calculate the taxes based on the user's province
  def calculate_taxes(cart)
    province = current_user.province || 'ON'  # Default to Ontario if province is not set
    tax_rate = case province
               when 'ON' then 0.13  # HST for Ontario
               when 'BC' then 0.12  # GST + PST for BC
               else 0.05  # Default GST
               end
    cart.cart_items.sum { |item| item.product.price * item.quantity } * tax_rate
  end
end
