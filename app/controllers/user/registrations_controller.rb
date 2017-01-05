class User
  class RegistrationsController < Devise::RegistrationsController
    prepend_before_action :check_captcha, only: [:create]

    def after_inactive_sign_up_path_for(resource)
      set_flash_message! :notice, ''
      page_path 'confirm', email: resource.email
    end

    private

    def check_captcha
      unless verify_recaptcha
        self.resource = resource_class.new sign_up_params
        respond_with_navigational(resource) { render :new }
      end
    end
  end
end
