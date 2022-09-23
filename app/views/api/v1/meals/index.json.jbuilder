# frozen_string_literal: true
json.items do
  json.array! @meals, partial: 'api/v1/meals/meal', as: :meal
end
json.total_items @total
