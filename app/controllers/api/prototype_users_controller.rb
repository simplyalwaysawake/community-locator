# frozen_string_literal: true

module API
  class PrototypeUsersController < API::APIController
    def create
      @prototype_user = PrototypeUser.new(prototype_user_params)

      if @prototype_user.save
        render json: @prototype_user, status: :created
      else
        render json: @prototype_user.errors, status: :unprocessable_entity
      end
    end

    private

    def prototype_user_params
      params.require(:prototype_user).permit(:email, :first_name, :last_name)
    end
  end
end
