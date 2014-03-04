json.array! DatasetUrlField.all do |field|
    json.id field.id
    json.dataset_id field.dataset_id
    json.label field.label
    json.url field.url
    json.type "DatasetUrlField"
end
