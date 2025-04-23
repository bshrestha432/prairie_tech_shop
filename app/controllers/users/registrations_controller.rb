class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create, :update]

  private

  # Modify the sign_up_params to permit province_id and address fields
  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :province_id)
  end

  # Override the account_update_params to permit address fields if needed (for updating user profile after signup)
  def account_update_params
    params.require(:user).permit(:current_password, :username, :email, :password, :password_confirmation, :province_id)
  end

  # Ensure address fields are handled for the user during registration or profile update
  def configure_permitted_parameters
    # For the sign-up process (new user registration)
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation, :province_id])

    # For the account update process (updating user profile)
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :password_confirmation, :province_id])
  end
end
