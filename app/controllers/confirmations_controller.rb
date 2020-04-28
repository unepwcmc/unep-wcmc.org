class ConfirmationsController < Devise::ConfirmationsController
  skip_before_filter :authenticate_user!
  before_action :pre_checks, only: :show
  before_action :set_user_update, only: :update

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

  def set_user_update
    # No checks as user must pass confirmation to see the show page - and ergo to update their password
    @user = User.confirm_by_token(params[:confirmation_token])
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def pre_checks
    @found_user = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
    if @found_user
      if @found_user.id.nil?
        flash[:error] = 'Invalid or already confirmed confirmation token. Please contact your administrator to resend confirmation instructions.'
        redirect_to '/'
        return
      elsif !@found_user.id.nil?
        if @found_user != current_user && !@found_user.confirmed_at.nil?
          sign_out current_user
          # To stop users using multiple confirmation links if signed in with one account already.
          flash[:notice] = "Account already confirmed. Please sign in (again if you have been logged out)."
          redirect_to new_user_session_path
          return
        elsif @found_user != current_user && @found_user.confirmed_at.nil?
          sign_out current_user
          flash[:notice] = "Signed you out. Please confirm your new account."
          @user = User.confirm_by_token(params[:confirmation_token])
        end
      end
    end
  end
end
