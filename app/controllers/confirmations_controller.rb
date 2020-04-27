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
    if !params[:confirmation_token] || params[:confirmation_token].empty?
      flash[:notice] = 'Missing confirmation token. Please contact your administrator to resend confirmation instructions.'
      redirect_to '/'
    end
    @user = User.confirm_by_token(params[:confirmation_token])
    # If confirm_by_token cannot find user
    if @user.id.nil?
      flash[:notice] = 'Invalid confirmation token. Please contact your administrator to resend confirmation instructions.'
      redirect_to '/'
    end
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
