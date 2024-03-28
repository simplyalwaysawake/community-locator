# frozen_string_literal: true

class CreateOptions < ActiveRecord::Migration[7.1]
  def change
    create_table :options do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :community_range, null: false

      t.timestamps
    end
  end
end
