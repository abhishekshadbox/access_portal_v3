class ApplicationController < ActionController::API
    before_action :check_age_group_access
    include Pundit

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def user_not_authorized
    	render json: { error: "You are not authorized to perform this action." }, status: :forbidden
    end

    def check_age_group_access
			return if current_user.nil?

			if current_user.age_group == "under_13" && !current_user.parental_consent
					render json: { error: "Parental consent required" }, status: :unauthorized
			end
    end
end
