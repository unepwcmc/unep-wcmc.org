class DatasetUrlField < DatasetField

  def self.for_dataset(dataset)
    where(dataset_id: dataset.id)
  end

  def self.destroy_for_dataset(dataset)
    for_dataset(dataset).destroy_all
  end

  def custom_label
  	@custom_label
  end
end
