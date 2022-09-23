# frozen_string_literal: true

json.first_count @first_count
json.second_count @second_count
json.stats do
  json.array! @stats do |stat|
    json.extract! stat, :user_id, :user_name, 'day_0', 'day_1', 'day_2', 'day_3', 'day_4', 'day_5', 'day_6'
  end
end
json.total_stats @total
