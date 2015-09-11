if @form
  json.array! @form.attachments do |a|
    json.id a.id
    json.name a.name
    if a.file.present?
      json.url a.file.url
      json.filename a.file_file_name
    end
  end
else
  json.array!
end
