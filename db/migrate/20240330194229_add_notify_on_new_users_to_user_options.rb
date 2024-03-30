class AddNotifyOnNewUsersToUserOptions < ActiveRecord::Migration[7.1]
  def change
    add_column :user_options, :notify_on_new_users, :boolean
  end
end
