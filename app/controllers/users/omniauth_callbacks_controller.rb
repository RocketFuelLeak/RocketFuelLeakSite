class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def all
        user = User.from_omniauth(request.env["omniauth.auth"])

        if user.persisted?
            set_flash_message(:notice, :success, kind: "service") if is_navigational_format?
            sign_in_and_redirect user, event: :authentication
        else
            session["devise.user_attributes"] = user.attributes
            redirect_to new_user_registration_url
        end
    end

    alias_method :github, :all
    alias_method :facebook, :all
    alias_method :twitter, :all
    alias_method :google_oauth2, :all
end
