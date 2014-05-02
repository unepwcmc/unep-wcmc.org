module ProgrammesHelper
  def programmes
    ::Programme.where(parent_programme_id: nil).includes(
      employees: [blocks: [:files]],
      subprogrammes:
        [employees: [blocks: [:files]]])
  end
end
