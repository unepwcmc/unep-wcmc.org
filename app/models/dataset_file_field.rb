class DatasetFileField < DatasetField
  has_attached_file :file
  do_not_validate_attachment_file_type :file

  def self.for_dataset(dataset)
    where(dataset_id: dataset.id)
  end

  def self.destroy_for_dataset(dataset)
    for_dataset(dataset).destroy_all
  end

  def custom_label
    @custom_label
  end

  def removed
    @removed
  end
end
