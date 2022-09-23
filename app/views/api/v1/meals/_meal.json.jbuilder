# frozen_string_literal: true

json.extract! meal, :id, :user_id, :food_name, :calorie_count, :price, :created_at, :updated_at
json.took_at meal.took_at.strftime('%Y-%m-%d')
if @current_user.has_role?(:admin)
  json.user do
    json.partial! 'api/v1/users/user', user: meal.user
  end
end
