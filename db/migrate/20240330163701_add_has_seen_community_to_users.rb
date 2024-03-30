# frozen_string_literal: true

class AddHasSeenCommunityToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :has_seen_community, :boolean, default: false, null: false
  end
end
