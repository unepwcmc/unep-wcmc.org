class Admin::ProgrammesController < Admin::Cms::BaseController

  before_action :build_programme,  :only => [:new, :create]
  before_action :load_programme,   :only => [:edit, :update, :destroy]

  def index
    @programmes = Programme.order("name ASC").page(params[:page])
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
    @programme.save!
    flash[:success] = 'Programme created'
    redirect_to :action => :index
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = 'Failed to create Programme'
    render :action => :new
  end

  def update
    @programme.update_attributes!(programme_params)
    flash[:success] = 'Programme updated'
    redirect_to :action => :index
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = 'Failed to update Programme'
    render :action => :edit
  end

  def destroy
    @programme.destroy
    flash[:success] = 'Programme deleted'
    redirect_to :action => :index
  end

protected

  def build_programme
    @programme = Programme.new(programme_params)
  end

  def load_programme
    @programme = Programme.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Programme not found'
    redirect_to :action => :index
  end

  def programme_params
    params.fetch(:programme, {}).permit(:name, :phone_number, :email)
  end
end
