# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  encrypts :private_api_key
  blind_index :private_api_key

  before_create :set_private_api_key

  validates :name, :email, :per_day_calorie_limit, :per_month_price_limit, presence: true
  validates :email, uniqueness: { case_sensitive: false }, length: { maximum: 50 }

  validates :private_api_key, uniqueness: true, allow_blank: true

  has_many :meals, class_name: 'Meal', foreign_key: 'user_id', dependent: :destroy

  def daily_calorie_limit_exceeded
    meals.took_today.sum(:calorie_count) >= per_day_calorie_limit
  end

  def monthly_price_limit_exceeded
    meals.took_this_month.sum(:price) >= per_month_price_limit
  end

  private

  def set_private_api_key
    self.private_api_key = SecureRandom.hex if private_api_key.nil?
  end
end
