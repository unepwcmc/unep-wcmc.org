json.array! @employees do |employee|
  json.name cms_block_content(:name, employee)
  json.id employee.id
end
