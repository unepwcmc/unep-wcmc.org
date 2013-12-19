class Admin::EmployeesController < Admin::Cms::PagesController
  skip_before_filter :load_admin_site
  prepend_before_action :set_site

  def index
    super
    @page = @site.pages.root
    @pages = @page.children
  end

  def update
    if @page.save
      flash[:success] = I18n.t("cms.pages.updated")
    else
      flash[:error] = I18n.t("cms.pages.update_failure")
    end
    redirect_to action: :edit
  end

  protected

  def build_cms_page
    @page = @site.pages.new(page_params)
    @page.parent ||= @site.pages.root
    @page.layout ||= @site.layouts.find_by_identifier('employee')
  end

  private

  def set_site
    @site = ::Cms::Site.find_by_identifier('employees')
  end
end