class Api::GeoipController < ApplicationController

  def after_update_path_for(resource)
    api_path
  end
  
  def index
    client_ip = remote_ip()
    if client_ip == 'GB'
      render :json => {:country_code2=>"GB", :country_name=>"United Kingdom"}
    else
      geo = GeoIP.new(GEO_IP_CONFIG['country_db']).country(client_ip)
      render :json => geo
    end
  end

  private

  def remote_ip
    if request.remote_ip == '127.0.0.1'
      # Default to GB
      'GB'
    else
      request.remote_ip
    end
  end

end
