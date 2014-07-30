# This is the base class for integrating CMS pages with custom resource types.
# It adds ability to save custom resources alongside standard pages. Known resources that
# use this ability are: about us pages, datasets, employees' profiles, expertise pages,
# featured projects, news items, policies and vacancies. Extending this class requires
# defining CMS site name, name of the CMS layout to be used as default for new resources
# and method for saving custom resources.

class Admin::PageResourcesController < Admin::Cms::PagesController
  skip_before_filter :load_admin_site
  prepend_before_action :set_site
  before_action :set_editions

  def new
    @page.is_published = false
  end

  def index
    super
    @pages = @page.children
  end

  def update
    if save
      create_edition
      flash[:success] = I18n.t("cms.pages.updated")
    else
      flash[:error] = I18n.t("cms.pages.update_failure")
    end
    redirect_to action: :edit
  end

  def create
    if save
      create_edition
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

  def set_editions
    @editions = ::Edition.where("resource_id IN (?)", @page.children.map(&:id)).order("created_at DESC").load
  end

  def create_edition
    Edition.create(user: current_user, resource: @page)
  end

  def save
    if @page == @site.pages.root
      @page.save
    else
      save_resources
    end
  end

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
    @page = ::Cms::Page.find_by_slug(site_identifier)
    @site = @page.site
  end

  def set_locale
    "en"
  end
end
