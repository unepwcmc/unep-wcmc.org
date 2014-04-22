module ProgrammesHelper
  def programmes
    ::Programme.includes(employees: [blocks: [:files]])
  end
end
