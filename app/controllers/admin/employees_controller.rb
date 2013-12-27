class Admin::EmployeesController < Admin::Cms::PagesController
  skip_before_filter :load_admin_site
  prepend_before_action :set_site
  before_action :set_programmes,   :only => [:edit, :new]
  before_action :set_employment,   :only => [:edit, :new]

  def index
    super
    @page = @site.pages.root
    @pages = @page.children
  end

  def update
    if @page.save && employment.save
      flash[:success] = I18n.t("cms.pages.updated")
    else
      flash[:error] = I18n.t("cms.pages.update_failure")
    end
    redirect_to action: :edit
  end

  def create
    if @page.save && employment.save
      flash[:success] = I18n.t('cms.pages.created')
      redirect_to :action => :edit, :id => @page
    else
      flash.now[:error] = I18n.t('cms.pages.creation_failure')
      render :action => :new
    end
  end

  protected

  def build_cms_page
    @page = @site.pages.new(page_params)
    @page.parent ||= @site.pages.root
    @page.layout ||= @site.layouts.find_by_identifier('employee')
  end

  private

  def set_programmes
    @programmes = Programme.all
  end

  def set_employment
    @employment = Employment.for_programmes.for_employee(@page).first
  end

  def employment
    ProgrammeEmploymentBuilder.new(employment: employment_params, employee: @page)
  end

  def employment_params
    params.require(:programme).permit(:id, :role)
  end

  def set_site
    @site = ::Cms::Site.find_by_identifier('employees')
  end
end
