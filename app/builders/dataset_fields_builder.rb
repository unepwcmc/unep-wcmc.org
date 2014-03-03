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
        if !params[:custom_label].empty?
          params[:label] = params[:custom_label]
        end
        update_field(params)
      else
        create_field(params)
      end
    end
  end

  private

  def create_field(params)
    params.delete(:custom_label)
    DatasetField.create(params)
  end

  def update_field(params)
    if params[:removed]
      if params[:type] == "DatasetUrlField"
        DatasetUrlField.find(params[:id]).destroy
      else 
        DatasetFileField.find(params[:id]).destroy
      end   
    else 
      unless params[:file]
        params.delete(:file)
      end
      params.delete(:custom_label)    
      DatasetField.find(params[:id]).update(params)
    end
  end

end
