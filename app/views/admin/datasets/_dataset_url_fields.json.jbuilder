json.array! @url_fields do |field|
    json.id field.id
    json.custom_label field.custom_label
    json.removed field.removed
    json.label field.label
    json.url field.url
    json.type "DatasetUrlField"
end
