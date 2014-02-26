class Api::GeoipController < ApplicationController

  def after_update_path_for(resource)
    api_path
  end
  
  def index
    client_ip = request.remote_ip
    geo = GeoIP.new(GEO_IP_CONFIG['country_db']).country(client_ip)
    if geo[:country_code] == 0
      render :json => {:country_code2=>"GB", :country_name=>"United Kingdom"}
    else
      render :json => geo
    end
  end

end
