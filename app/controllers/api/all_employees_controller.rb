class Api::AllEmployeesController < ApplicationController

  def after_update_path_for(resource)
    api_path
  end

  def index
  	employees = Cms::Page.joins(:site).where('cms_sites.identifier' => 'employees').map{|e| e["label"]}
  	render :json => employees
  end
end