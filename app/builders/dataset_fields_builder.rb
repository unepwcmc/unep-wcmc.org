class DatasetFieldsBuilder
  def initialize(params) 
    @fields_params = params[:fields_params]
    @dataset = params[:dataset]
  end

  def save
    @fields_params.each do |params|
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
    if params[:type] == "DatasetFileField"

    else
      DatasetField.update(params)
    end
  end

end
