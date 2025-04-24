class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Permit username and address fields during sign up and account update
  def configure_permitted_parameters
    # Adding address fields in the permitted attribute
    added_attrs = [:email, :password, :password_confirmation, :remember_me,
                   :username, :address_line1, :city, :postal_code, :country]

    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end
end
