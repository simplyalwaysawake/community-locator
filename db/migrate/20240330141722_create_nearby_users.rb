class CreateNearbyUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :nearby_users do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :nearby_user_id

      t.timestamps
    end
  end
end
