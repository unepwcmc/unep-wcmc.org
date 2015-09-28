class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  BOGUS_REQUEST_FORMATS = ['*/*;', '/;', 'hc/url;*/*']
  DEFAULT_RESPONSE_FORMAT = :html
  before_filter :set_default_response_format

  def set_default_response_format
    request.format = DEFAULT_RESPONSE_FORMAT if request.format.in? BOGUS_REQUEST_FORMATS
  end

  def after_sign_in_path_for(resource)
    comfy_admin_cms_path
  end

  # this end-point to be used to test exception notifier
  def test_exception_notifier
    raise 'This is a test. This is only a test.'
  end

end
