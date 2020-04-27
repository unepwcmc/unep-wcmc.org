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
    if params[:confirmation_token].blank?
      flash[:notice] = 'Missing confirmation token. Please contact your administrator to resend confirmation instructions.'
      redirect_to '/'
      return
    end
    @user = User.confirm_by_token(params[:confirmation_token])
    # Handling errors if confirmation_token is valid
    post_checks
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def post_checks
    if @user
      if !@user.confirmed_at.nil?
        flash[:notice] = "Email address already confirmed, please sign in."
        sign_out current_user
        # To stop users using multiple confirmation links if signed in with one account already.
        redirect_to new_user_session_path
      elsif @user.id.nil?
        flash[:notice] = 'Invalid confirmation token. Please contact your administrator to resend confirmation instructions.'
        redirect_to '/'
      end
    end
  end
end
