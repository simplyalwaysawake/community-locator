# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create] # rubocop:disable Rails/LexicallyScopedActionFilter
    before_action :configure_account_update_params, only: [:update]

    prepend_before_action :check_captcha, only: [:create] # rubocop:disable Rails/LexicallyScopedActionFilter

    def edit
      if params['welcome']
        render :welcome
      else
        render :edit
      end
    end

    def update
      if current_user.update(user_params)
        notice = if current_user.pending_reconfirmation?
                   I18n.t('profile_updated_pending_reconfirmation')
                 else
                   I18n.t('profile_updated')
                 end
        redirect_to root_path, notice:
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(
        :sign_up,
        keys: %i[name email telegram password]
      )
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(
        :account_update,
        keys: %i[name email telegram password]
      )
    end

    def user_params
      params.require(:user).permit(:name, :email, :telegram, :password)
    end

    def after_inactive_sign_up_path_for(resource) # rubocop:disable Lint/UnusedMethodArgument
      new_user_session_path
    end

    private

    def check_captcha
      return if verify_recaptcha

      self.resource = resource_class.new user_params
      resource.validate

      flash[:alert] = I18n.t('recaptcha_verification_failed')
      render :new, status: :unprocessable_entity
    end
  end
end
