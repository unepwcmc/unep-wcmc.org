json.array! @vacancy_fields do |field|
  json.id field.id
  json.custom_label field.custom_label
  json.removed field.removed
  json.label field.label
  if field.file.present?
    json.url field.file.url
    json.filename field.file_file_name
  end
end
