json.array! @employments do |employment|
  json.employee_id employment.employee_id.to_s
  json.role employment.role
end
