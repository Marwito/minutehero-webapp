class RegistrationsController < Devise::RegistrationsController
  def after_inactive_sign_up_path_for(resource)
    set_flash_message! :notice, ''
    page_path 'confirm', email: resource.email
  end
end
