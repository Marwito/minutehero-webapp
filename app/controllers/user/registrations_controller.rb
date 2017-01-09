class User
  class RegistrationsController < Devise::RegistrationsController
    prepend_before_action :check_captcha, only: [:create]

    def after_inactive_sign_up_path_for(resource)
      set_flash_message! :notice, ''
      page_path 'confirm', email: resource.email
    end

    protected

    def update_resource(resource, params)
      resource.update_without_password(params)
    end

    private

    def check_captcha
      unless verify_recaptcha
        self.resource = resource_class.new sign_up_params
        respond_with_navigational(resource) { render :new }
      end
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name,
                                                         :last_name])
      devise_parameter_sanitizer
          .permit(:account_update, keys: [:first_name, :last_name, :company,
                                          :country, :time_zone])
    end

  end
end
