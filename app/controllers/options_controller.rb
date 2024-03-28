# frozen_string_literal: true

class OptionsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @options = current_user.options
  end

  def update
    @options = current_user.options
    if @options.update(options_params)
      redirect_to root_path, notice: 'Options saved' # rubocop:disable Rails/I18nLocaleTexts
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def options_params
    params.require(:options).permit(:community_range, :user_id)
  end
end
