class ConfirmationsController < Devise::ConfirmationsController
  skip_before_filter :authenticate_user!
  before_action :set_user, only: [:show, :update]

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

  def set_user
    pre_checks
    @user = User.confirm_by_token(params[:confirmation_token])
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def pre_checks
    if params[:confirmation_token].blank?
      flash[:error] = 'Missing confirmation token. Please contact your administrator to resend confirmation instructions.'
      redirect_to '/'
      return
    end
    @found_user = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
    if @found_user
      if @found_user.id.nil?
        flash[:error] = 'Invalid confirmation token. Please contact your administrator to resend confirmation instructions.'
        redirect_to '/'
      elsif !@found_user.confirmed_at.nil?
        sign_out current_user
        # To stop users using multiple confirmation links if signed in with one account already.
        flash[:error] = "Email address already confirmed, please sign in."
        redirect_to new_user_session_path
      end
    end
  end
end
