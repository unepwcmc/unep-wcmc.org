class Api::EmployeesController < ApplicationController

  def after_update_path_for(resource)
    api_path
  end

  def index
    employees = Comfy::Cms::Page.joins(:site).
      where('comfy_cms_sites.identifier' => 'employees').
      order('comfy_cms_pages.label ASC').map{|e| e["label"]}
  	render :json => employees
  end
end
