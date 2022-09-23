# frozen_string_literal: true

class AddPerDayCalorieLimitToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :per_day_calorie_limit, :float, default: 2100
    add_column :users, :per_month_price_limit, :float, default: 1000
  end
end
