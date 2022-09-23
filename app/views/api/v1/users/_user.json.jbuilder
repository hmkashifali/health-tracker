# frozen_string_literal: true

json.extract! user, :id, :email, :name, :per_day_calorie_limit, :per_month_price_limit, :created_at, :updated_at
json.daily_calorie_limit_exceeded user.daily_calorie_limit_exceeded
json.monthly_price_limit_exceeded user.monthly_price_limit_exceeded
json.token user.private_api_key
json.is_admin user.has_role?(:admin)
