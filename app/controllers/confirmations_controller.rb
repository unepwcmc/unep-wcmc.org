class ConfirmationsController < Devise::ConfirmationsController
  skip_before_filter :authenticate_user!
  before_action :set_user, only: [:edit, :update]

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
    token = Devise.token_generator.digest(User, :confirmation_token, params[:confirmation_token])
    @user = User.find_by_confirmation_token!(token)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
