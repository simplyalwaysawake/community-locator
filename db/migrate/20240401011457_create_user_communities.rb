# frozen_string_literal: true

class CreateUserCommunities < ActiveRecord::Migration[7.1]
  def change
    create_table :user_communities do |t|
      t.references :user, null: false, foreign_key: true
      t.text :nearby_user_ids, array: true, default: []

      t.timestamps
    end

    User.find_each do |user|
      nearby_user_ids = NearbyUser.where(user_id: user.id).pluck(:nearby_user_id)
      user.create_saved_community(nearby_user_ids:) unless nearby_user_ids.empty?
    end
  end
end
