class Api::GeoipController < ApplicationController

  def after_update_path_for(resource)
    api_path
  end
  
  def index
    iso2 = request.query_parameters['country']
    if iso2
      country = Country.find_by!(:iso2 => iso2)
      render :json => {
        :country_code2=>country.iso2, :country_name=>country.name}
    else
      client_ip = request.remote_ip
      geo = GeoIP.new(GEO_IP_CONFIG['country_db']).country(client_ip)
      if geo[:country_code] == 0
        render :json => {:country_code2=>"GB", :country_name=>"United Kingdom"}
      else
        render :json => geo
      end
    end
  end

end
