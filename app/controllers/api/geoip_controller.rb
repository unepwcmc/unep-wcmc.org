class Api::GeoipController < ApplicationController

  def after_update_path_for(resource)
    api_path
  end
  
  def index
    client_ip = remote_ip()
    geo = GeoIP.new(GEO_IP_CONFIG['country_db']).country(client_ip)
    render :json => geo
  end

  private

  def remote_ip
    if request.remote_ip == '127.0.0.1'
      # Hard coded remote address
      '176.25.192.132'
    else
      request.remote_ip
    end
  end

end
