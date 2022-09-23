# frozen_string_literal: true

class Meal < ApplicationRecord
  belongs_to :user

  validates :food_name, :took_at, :calorie_count, :price, presence: true
  validates :calorie_count, :price, numericality: { greater_than_or_equal_to: 0 }

  scope :took_from, ->(from) { where('took_at >= ?', from) }
  scope :took_today, -> { took_from(DateTime.now.beginning_of_day) }
  scope :took_this_month, -> { took_from(DateTime.now.beginning_of_month) }
end
