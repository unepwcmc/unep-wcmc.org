json.array! DatasetFileField.all  do |field|
    json.id field.id
    json.dataset_id field.dataset_id
    json.label field.label
    if field.file.present?
      json.url field.file.url
      json.filename field.file_file_name
    end
    json.type "DatasetFileField"
end
