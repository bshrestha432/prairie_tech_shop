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
    # Set the Stripe secret key (from Rails credentials)
    Stripe.api_key = Rails.application.credentials.stripe[:secret_key]  # Ensure Stripe is authenticated

    @cart = current_user.cart
    @invoice = calculate_invoice(@cart)

    payment_method_id = params[:payment_method_id]

    # Create a PaymentIntent to confirm the payment using Stripe's API
    begin
      payment_intent = Stripe::PaymentIntent.create({
        amount: (@invoice[:total_price] * 100).to_i,  # Amount in cents (Stripe works in the smallest currency unit)
        currency: 'usd',
        payment_method: payment_method_id,  # Payment method ID received from Stripe Elements on the frontend
        confirm: true,  # Automatically confirm the payment
      })

      # If payment was successful, create the order
      if payment_intent.status == 'succeeded'
        # Build the order with the current user's data
        @order = current_user.orders.build(order_params)
        @order.total_price = @invoice[:total_price]
        @order.tax = @invoice[:taxes]
        @order.payment_status = 'paid'  # Set the payment status to "paid"
        @order.payment_id = payment_intent.id  # Save the Stripe Payment ID to the order

        # Save the order to the database
        if @order.save
          # Associate cart items with the order
          @cart.cart_items.each do |cart_item|
            @order.order_items.create(
              product: cart_item.product,
              quantity: cart_item.quantity,
              price: cart_item.product.price
            )
          end

          # Clear the cart after checkout
          current_user.cart.cart_items.destroy_all

          # Redirect to the order confirmation page with a success message

          # define route, which controller which method should it be redirected to.
          redirect_to order_path(@order), notice: "Your order has been placed successfully!"
        else
          flash[:alert] = "There was a problem processing your order."
          render :show
        end
      else
        flash[:alert] = "Payment failed. Please try again."
        render :show
      end
    rescue Stripe::CardError => e
      flash[:alert] = e.message
      render :show
    rescue Stripe::AuthenticationError => e
      flash[:alert] = "Stripe authentication error: #{e.message}"
      render :show
    rescue Stripe::APIConnectionError => e
      flash[:alert] = "Network error with Stripe: #{e.message}"
      render :show
    rescue Stripe::StripeError => e
      flash[:alert] = "Stripe error: #{e.message}"
      render :show
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

  # Strong parameters for order creation
  def order_params
    # If order params aren't present, use an empty hash
    if params[:order].present?
      params.require(:order).permit(:shipping_address)
    else
      # Get shipping address from user's customer record or use default
      { shipping_address: current_user.customer&.address || "Default address" }
    end
  end
end
