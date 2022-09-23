# frozen_string_literal: true

module Api
  module V1
    class MealsController < Api::V1::BaseController
      before_action :set_meal, only: %i[show update destroy]
      before_action :set_default_query_for_ransack

      def index
        @q = Meal.where(user_condition).order(took_at: :desc).ransack(JSON.parse(params[:q]))
        @total = @q.result(distinct: true).count
        @meals = @q.result(distinct: true).paginate(page: page, per_page: per_page)
      end

      def show; end

      def create
        @meal = Meal.where(user_condition).build(meal_params)
        if @meal.save
          render :show, status: :created
        else
          render json: { message: @meal.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @meal.update(meal_params)
          render :show, status: :ok
        else
          render json: { message: @meal.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @meal.destroy
        render :show, status: :ok
      end

      def admin_stats
        unless current_user.has_role?(:admin)
          render status: :unauthorized, json: { error: 'You are not authorized to access this resource' }
          return
        end
        @first_count = Meal.where(user_condition).ransack(created_at_gteq: 6.days.ago.beginning_of_day).result.count
        @second_count = Meal.where(user_condition).ransack(created_at_gteq: 13.days.ago.beginning_of_day).result.count
        @second_count -= @first_count
        @stats = ave_per_day_stats
      end

      def calories_per_day
        @q = Meal.where(user_condition).order(took_at: :desc).ransack(JSON.parse(params[:q]))
        @meals = @q.result(distinct: true).group('DATE(took_at)').select('SUM(calorie_count) AS calories, took_at')
        if params[:load_exceeding_only] == 'true'
          @meals = @meals.having('calories >= ?',
                                               current_user.per_day_calorie_limit)
        end
      end

      def expenses_per_month
        @q = Meal.where(user_condition).order(took_at: :desc).ransack(JSON.parse(params[:q]))
        @meals = @q.result(distinct: true).group('YEAR(took_at), MONTH(took_at)').select('SUM(price) AS total_price, took_at')
        if params[:load_exceeding_only] == 'true'
          @meals = @meals.having('total_price >= ?',
                                               current_user.per_month_price_limit)
        end
      end

      private

      def ave_per_day_stats
        q = User.ransack(JSON.parse(params[:q])).result
        @total = q.count
        users = q.paginate(page: page, per_page: per_page)
        users.map do |user|
          stat = { user_id: user.id, user_name: user.name }
          7.times do |n|
            stat["day_#{n}"] =
              ActiveRecord::Base.connection.execute(generate_ave_query(n.days.ago, user.id)).to_a.first.first || 0
          end
          stat
        end
      end

      def meal_params
        permitted = %i[food_name calorie_count price took_at]
        permitted << :user_id if current_user.has_role?(:admin)
        params.require(:meal).permit(permitted)
      end

      def generate_ave_query(date, user_id)
        "SELECT AVG(calorie_count)
    FROM meals
    WHERE took_at >= '#{date.beginning_of_day.strftime('%Y-%m-%d %H:%M:%S')}' AND took_at <= '#{date.end_of_day.strftime('%Y-%m-%d %H:%M:%S')}' AND user_id = '#{user_id}'"
      end

      def set_default_query_for_ransack
        params[:q] = '{}' unless params[:q].present?
      end

      def set_meal
        @meal = Meal.where(user_condition).find(params[:id])
      end

      def user_condition
        current_user.has_role?(:admin) ? '' : { user_id: current_user.id }
      end
    end
  end
end
