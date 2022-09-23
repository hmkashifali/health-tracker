# frozen_string_literal: true

module Api
  module V1
    MAX_PER_PAGE = 99999
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session
      rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
      before_action :authenticate

      attr_reader :current_user

      def page
        params[:page] || 1
      end

      def per_page
        params[:per_page].to_i > 0 ? params[:per_page] : MAX_PER_PAGE
      end

      private

      def authenticate
        authenticate_user_with_token || handle_bad_authentication
      end

      def authenticate_user_with_token
        authenticate_with_http_token do |token, _options|
          @current_user ||= User.find_by(private_api_key: token)
        end
      end

      def handle_bad_authentication
        render json: { message: 'Bad credentials' }, status: :unauthorized
      end

      def handle_not_found
        render json: { message: 'Record not found' }, status: :not_found
      end
    end
  end
end
