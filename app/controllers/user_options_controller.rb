# frozen_string_literal: true

class UserOptionsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @options = current_user.user_options || UserOptions.new
    @selected_community_range = @options&.community_range || UserOptions::DEFAULT_COMMUNITY_RANGE
  end

  def create
    @options = current_user.create_user_options(options_params)

    if @options.save
      redirect_to root_path, notice: I18n.t('options_updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update
    @options = current_user.user_options

    values = options_params
    values[:notify_on_new_users] = %w[on true].include? values[:notify_on_new_users]

    Rails.logger.info("Values: #{values}")

    if @options.update(values)
      redirect_to root_path, notice: 'Options saved' # rubocop:disable Rails/I18nLocaleTexts
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def options_params
    params.require(:user_options).permit(:user_id, :community_range, :notify_on_new_users)
  end
end
