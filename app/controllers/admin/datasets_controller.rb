class Admin::DatasetsController < Admin::PageResourcesController
  before_action :set_fields, only: [:edit, :create]

  private

  def save_resources
    if @page.save
      url_fields.save
      file_fields.save
    end
  end

  def site_identifier
    'resources-and-data'
  end

  def layout_identifier
    'dataset'
  end

  def set_fields
    @url_fields ||= DatasetUrlField.for_dataset(@page)
    @file_fields ||= DatasetFileField.for_dataset(@page)
  end

  def dataset_url_fields_params
    params[:urlFieldForms].try(:values) || []
  end

  def dataset_file_fields_params
    params[:fileFieldForms].try(:values) || []
  end

  def file_fields
    DatasetFieldsBuilder.new(fields_params: dataset_file_fields_params, dataset: @page, type: "DatasetFileField")
  end

  def url_fields
    DatasetFieldsBuilder.new(fields_params: dataset_url_fields_params, dataset: @page, type: "DatasetUrlField")
  end

end
