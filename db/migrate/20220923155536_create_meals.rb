# frozen_string_literal: true

class CreateMeals < ActiveRecord::Migration[6.1]
  def change
    create_table :meals do |t|
      t.string :food_name
      t.datetime :took_at
      t.float :calorie_count
      t.float :price
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
