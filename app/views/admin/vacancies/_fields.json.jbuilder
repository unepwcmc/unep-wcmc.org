if @form
  json.array! @form.fields do |field|
    json.id field.id
    json.label field.name
    json.type field.type
  end
else
  json.array!
end
