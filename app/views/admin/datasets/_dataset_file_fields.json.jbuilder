json.array! @file_fields do |field|
    json.id field.id
    json.custom_label ""
    json.removed false
    json.label field.label
    json.file field.file
    json.type "DatasetFileField"
end
