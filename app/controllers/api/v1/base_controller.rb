module Api
  module V1
    class BaseController < ActionController::API
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActionController::ParameterMissing, with: :bad_request
      rescue_from ArgumentError, with: :bad_request

      private

      def not_found(exception)
        render json: {
          error: "Not Found",
          message: exception.message
        }, status: :not_found
      end

      def bad_request(exception)
        render json: {
          error: "Bad Request",
          message: exception.message
        }, status: :bad_request
      end
    end
  end
end
