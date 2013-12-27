module ProgrammesHelper
  def programmes
    ::Programme.includes(:employees)
  end
end
