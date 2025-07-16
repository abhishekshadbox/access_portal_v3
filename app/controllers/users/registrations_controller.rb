# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    # layout 'application'

    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]

    def new
      super
    end
    protected

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [
        :full_name, :date_of_birth, :parent_email, :parental_consent
      ])
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [
        :full_name, :date_of_birth, :parent_email, :parental_consent
      ])
    end
  end
end
