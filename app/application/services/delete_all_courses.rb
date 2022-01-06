# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module HobbyCatcher
  module Service
    # delete all courses from db
    class DeleteAllCourses
      include Dry::Transaction

      step :delete_all_courses

      private

      def delete_all_courses
        courses = delete_from_database

        Success(Response::ApiResult.new(status: :ok, message: courses))
      end

      def delete_from_database
        Repository::For.klass(Entity::Course).delete_all
      end
    end
  end
end
