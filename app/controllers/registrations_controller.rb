class Users::RegistrationsController < Devise::RegistrationsController
  # Allow users to edit their province along with other details
  def update
    # Remove password fields if they're blank (i.e., not changing the password)
    if password_blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    # Attempt to update the user with the provided params
    if current_user.update(user_params)
      redirect_to user_path(current_user), notice: 'Your province has been updated.'
    else
      render :edit
    end
  end

  private

  def user_params
    # Allow only the necessary fields for update
    params.require(:user).permit(:email, :province_id, :password, :password_confirmation)
  end

  # Check if the password fields are blank
  def password_blank?
    params[:user][:password].blank? && params[:user][:password_confirmation].blank?
  end
end
