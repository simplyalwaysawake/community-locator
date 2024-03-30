# frozen_string_literal: true

class AddNotifyOnNewUsersToUserOptions < ActiveRecord::Migration[7.1]
  def change
    add_column :user_options, :notify_on_new_users, :boolean, default: false, null: false
  end
end
