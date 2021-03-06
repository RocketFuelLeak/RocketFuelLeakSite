class Users::RegistrationsController < Devise::RegistrationsController
    def create
        if session[:omniauth].present?
            super
            session[:omniauth] = nil unless @user.new_record?
        else
            build_resource(sign_up_params)
            if not resource.recaptcha_required? or verify_recaptcha
                flash.delete :recaptcha_error
                super
                session[:omniauth] = nil unless @user.new_record?
            else
                flash.delete :recaptcha_error
                resource.valid?
                flash.now[:alert] = 'There was an error with the reCAPTCHA code below. Please re-enter the code.'
                resource.errors.add(:base, 'There was an error with the reCAPTCHA code below. Please re-enter the code.')
                clean_up_passwords resource
                respond_with resource
            end
        end
    end
end
