class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # rubocop: disable Metrics/MethodLength
  def self.provides_callback_for(provider)
    class_eval %{
      def #{provider}
        @user = User.find_for_oauth(env["omniauth.auth"], current_user)
        if User.country_supported?
          if @user.persisted?
            sign_in_and_redirect @user, event: :authentication
            if is_navigational_format?
              set_flash_message(:notice, :success, kind:
                                "#{provider}".capitalize)
            end
          else
            session["devise.#{provider}_data"] = env["omniauth.auth"]
            redirect_to new_user_registration_url
          end
        else
          redirect_to page_path('unsupported_country')
        end
      end
    }
  end
  # rubocop: enable all

  [:twitter, :facebook, :xing, :linkedin].each do |provider|
    provides_callback_for provider
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_signup_path(resource)
    end
  end
end
