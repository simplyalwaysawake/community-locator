# frozen_string_literal: true

class AddNameAndTelegramToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :name
      t.string :telegram
    end
  end
end
