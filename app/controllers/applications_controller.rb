class ApplicationsController < ApplicationController
  before_action :authenticate
  before_action :set_form, only: [:show]

  def index
    @forms = Form.order(created_at: :desc)
  end

  def show
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_form
    @form = Form.find(params[:id])
  end

  def authenticate
    redirect_to new_user_session_path unless current_user
  end

end
