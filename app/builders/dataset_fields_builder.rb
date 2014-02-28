class DatasetFieldsBuilder
  def initialize(params) 
    @fields_params = params[:fields_params]
    @dataset_id = params[:dataset].id
    @type = params[:type]
  end

  def save
    @fields_params.each do |params|
      params = params.merge(type: @type).merge(dataset_id: @dataset_id)
      if params[:id]
        update_field(params)
      else
        create_field(params)
      end
    end
  end

  private

  def create_field(params)
    DatasetField.create(params)
  end

  def update_field(params)
    unless params[:file]
      params.delete(:file)
    end
    DatasetField.find(params[:id]).update(params)
  end

end
