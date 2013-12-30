class Admin::DatasetsController < Admin::PageResourcesController

  private

  def save_resources
    @page.save
  end

  def site_identifier
    'resources-and-data'
  end

  def layout_identifier
    'dataset'
  end

end
