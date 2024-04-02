# frozen_string_literal: true

class DropNearbyUsers < ActiveRecord::Migration[7.1]
  def up
    drop_table :nearby_users
  end

  def down # rubocop:disable Metrics/MethodLength
    create_table :nearby_users do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :nearby_user_id

      t.timestamps
    end

    User.find_each do |user|
      nearby_user_ids = user.saved_community&.nearby_user_ids || []
      NearbyUser.insert_all( # rubocop:disable Rails/SkipsModelValidations
        nearby_user_ids.map { |id| { user_id: user.id, nearby_user_id: id } }
      )
    end
  end
end
