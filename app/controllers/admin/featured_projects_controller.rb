class Admin::FeaturedProjectsController < Admin::PageResourcesController
  before_action :set_employees
  before_action :build_employments, only: [:create, :update]

  def edit
    @employments = Employment.where(project_id: @page.id)
  end

  private

  def save_resources
    @page.save && @employments.save
  end

  def layout_identifier
    'featured-project'
  end

  def site_identifier
    'featured-projects'
  end

  def employments_params
    params[:employees].try(:values) || []
  end

  def set_employees
    @employees = ::Cms::Site.find_by_identifier("employees").pages.root.children
  end

  def build_employments
    @employments = ::ProjectEmploymentsBuilder.new(project: @page, employments: employments_params)
  end
end
