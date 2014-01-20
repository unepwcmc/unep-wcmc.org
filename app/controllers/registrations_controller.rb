class RegistrationsController < Devise::RegistrationsController
  def after_update_path_for(resource)
    admin_cms_path
  end
end
