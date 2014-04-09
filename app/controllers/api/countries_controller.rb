class Api::CountriesController < ApplicationController
  def after_update_path_for(resource)
    api_path
  end

  def index
    @country =  Api::Country.select("id, iso2, name")
    render :json => @country
  end
end
