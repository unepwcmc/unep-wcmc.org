module Admin::FeaturedProjectsHelper
  def employees_options
    options = @employees.map { |employee| [cms_page_content(:name, employee), employee.id] }
    return options_for_select(options)
  end
end
