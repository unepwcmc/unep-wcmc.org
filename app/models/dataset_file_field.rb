class DatasetFileField < DatasetField
  has_attached_file :file

  def self.for_dataset(dataset)
    where(dataset_id: dataset.id)
  end

  def self.destroy_for_dataset(dataset)
    for_dataset(dataset).destroy_all
  end
end
