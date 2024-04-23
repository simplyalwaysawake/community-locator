# frozen_string_literal: true

class CreatePrototypeUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :prototype_users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.timestamp :unsubscribed_at

      t.timestamps
    end
  end
end
