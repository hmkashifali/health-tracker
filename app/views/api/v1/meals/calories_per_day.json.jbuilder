# frozen_string_literal: true

json.array! @meals do |meal|
  json.extract! meal, :calories
  json.took_at meal.took_at.strftime('%Y-%m-%d')
end
