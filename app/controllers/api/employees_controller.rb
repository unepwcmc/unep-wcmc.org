class Api::EmployeesController < ApplicationController

  def after_update_path_for(resource)
    api_path
  end

  def index
    employees = Comfy::Cms::Page.joins(:site).
      where('cms_sites.identifier' => 'employees').
      order('cms_pages.label ASC').map{|e| e["label"]}
  	render :json => employees
  end
end
