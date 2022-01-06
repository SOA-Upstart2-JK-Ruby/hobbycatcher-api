# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module HobbyCatcher
  module Service
    # Store Courses to db
    class StoreCourses
      include Dry::Transaction

      step :store_courses_in_database

      private

      def store_courses_in_database(input)
        categories = input[:list]
        categories.each do |category|
          Repository::For.entity(category).update_courses(category)
        end
        Success(Response::ApiResult.new(status: :ok, message: 'Succeed'))
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :internal_error, message: e.message))
      end
    end
  end
end
