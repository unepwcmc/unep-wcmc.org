class Admin::DatasetsController < Admin::PageResourcesController
  before_action :set_fields

  private

  def save_resources
    @page.save && fields.save
  end

  def site_identifier
    'resources-and-data'
  end

  def layout_identifier
    'dataset'
  end

  def set_fields
    @url_fields = url_fields_for_dataset
    @file_fields = file_fields_for_dataset
  end

  def dataset_fields_params
    params[:dataset_fields].try(:values) || []
  end

  def fields
    DatasetFieldsBuilder.new(fields_params: dataset_fields_params, dataset: @page)
  end

end
