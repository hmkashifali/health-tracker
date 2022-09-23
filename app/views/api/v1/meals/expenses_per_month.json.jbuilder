# frozen_string_literal: true

json.array! @meals do |meal|
  json.extract! meal, :total_price
  json.month meal.took_at.strftime('%B %Y')
  json.beginning_of_month meal.took_at.beginning_of_month.strftime('%Y-%m-%d')
  json.current_date DateTime.now.end_of_day.strftime('%Y-%m-%d')
end
