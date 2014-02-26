module DatasetsHelper

  def url_fields_for_dataset
    @url_fields_for_dataset ||= DatasetUrlField.for_dataset(@cms_page)
  end

  def file_fields_for_dataset
    @file_fields_for_dataset ||= DatasetFileField.for_dataset(@cms_page)
  end

end
