class Admin::UsersController < Admin::Cms::BaseController

  before_action :build_user,  :only => [:new, :create]
  before_action :load_user,   :only => [:edit, :update, :destroy]

  def index
    @users = User.page(params[:page])
  end

  def show
    render
  end

  def new
    render
  end

  def edit
    render
  end

  def create
    @user.save!
    flash[:success] = 'User created'
    redirect_to :action => :index
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = 'Failed to create User'
    render :action => :new
  end

  def update
    @user.update_attributes!(user_params)
    flash[:success] = 'User updated'
    redirect_to :action => :index
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = 'Failed to update User'
    render :action => :edit
  end

  def destroy
    @user.destroy
    flash[:success] = 'User deleted'
    redirect_to :action => :index
  end

protected

  def build_user
    @user = User.new(user_params)
  end

  def load_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'User not found'
    redirect_to :action => :index
  end

  def user_params
    params.fetch(:user, {}).permit(:name, :email, :is_superadmin)
  end
end
