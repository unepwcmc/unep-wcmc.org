json.array! @url_fields do |field|
    json.id field.id
    json.label field.label
    json.url field.url
    json.type "DatasetUrlField"
end
