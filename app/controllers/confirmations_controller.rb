class ConfirmationsController < Devise::ConfirmationsController
  skip_before_filter :authenticate_user!
  before_action :pre_checks, only: [:show, :update]

  def update
    if @user.update(password_params)
      @user.confirm!
      flash[:notice] = "Your email address has been successfully confirmed. You can now login with your new credentials."
      redirect_to new_user_session_path
    else
      render action: :show
    end
  end

  def show
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def pre_checks
    @user = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
    if @user.id.nil? || !user_signed_in? && !@user.confirmed_at.nil?
      flash[:error] = 'Invalid or already confirmed confirmation token. Please contact your administrator to resend confirmation instructions.'
      redirect_to '/'
      return
    else
      if @user != current_user && user_signed_in?
        sign_out current_user
        # To stop users using multiple confirmation links if signed in with one account already.
        if @user.confirmed_at.nil?
          flash[:error] = "Please confirm your new account."
        else
          flash[:error] = "Account already confirmed. Please contact your administrator to resend confirmation instructions."
          redirect_to '/'
          return
        end
      end
    end
  end
end
