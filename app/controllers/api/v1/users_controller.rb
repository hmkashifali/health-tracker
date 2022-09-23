# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::BaseController
      def index
        @q = User.ransack(params[:q])
        @users = @q.result(distinct: true)
      end

      def me; end
    end
  end
end
