# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'landing#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      defaults format: :json do
        resources :meals, only: %i[index create show update destroy] do
          collection do
            get 'admin_stats'
            get 'calories_per_day'
            get 'expenses_per_month'
          end
        end
        resources :users, only: [:index] do
          collection do
            get 'me'
          end
        end
      end
    end
  end
end
