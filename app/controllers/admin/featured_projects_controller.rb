class Admin::FeaturedProjectsController < Admin::Cms::PagesController
  skip_before_filter :load_admin_site
  prepend_before_action :set_site
  before_action :set_employees
  before_action :build_employments, only: [:create, :update]

  def index
    super
    @page = @site.pages.root
    @pages = @page.children
  end

  def create
    if @page.save && @employments.save
      flash[:success] = I18n.t('cms.pages.created')
      redirect_to :action => :edit, :id => @page
    else
      flash.now[:error] = I18n.t('cms.pages.creation_failure')
      render :action => :new
    end
  end

  def update
    if @page.save && @employments.save
      flash[:success] = I18n.t("cms.pages.updated")
    else
      flash[:error] = I18n.t("cms.pages.update_failure")
    end
    redirect_to action: :edit
  end

  def edit
    @employments = Employment.where(project_id: @page.id)
  end

  protected

  def build_cms_page
    @page = @site.pages.new(page_params)
    @page.parent ||= @site.pages.root
    @page.layout ||= @site.layouts.find_by_identifier('featured-project')
  end

  private

  def employments_params
    params[:employees].try(:values) || []
  end

  def set_employees
    @employees = ::Cms::Site.find_by_identifier("employees").pages.root.children
  end

  def set_site
    @site = ::Cms::Site.find_by_identifier('featured-projects')
  end

  def build_employments
    @employments = ::EmploymentsBuilder.new(project: @page, employments: employments_params)
  end
end
