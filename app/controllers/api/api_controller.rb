# frozen_string_literal: true

module API
  class APIController < ActionController::API
    before_action :authenticate_user!
    before_action :authorize_admin!

    def authorize_admin!
      head :forbidden unless current_user.admin?
    end
  end
end
