# frozen_string_literal: true

class RenameOptions < ActiveRecord::Migration[7.1]
  def change
    rename_table :options, :user_options
  end
end
