class Admin::PageResourcesController < Admin::Cms::PagesController
  skip_before_filter :load_admin_site
  prepend_before_action :set_site

  def index
    super
    @page = @site.pages.root
    @pages = @page.children
  end

  def update
    if save_resources
      flash[:success] = I18n.t("cms.pages.updated")
    else
      flash[:error] = I18n.t("cms.pages.update_failure")
    end
    redirect_to action: :edit
  end

  def create
    if save_resources
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
    @page.layout ||= @site.layouts.find_by_identifier(layout_identifier)
  end

  private

  def save_resources
    raise NotImplementedError
  end

  def site_identifier
    raise NotImplementedError
  end

  def layout_identifier
    raise NotImplementedError
  end

  def set_site
    @site = ::Cms::Site.find_by_identifier(site_identifier)
  end
end
