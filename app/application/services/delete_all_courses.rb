# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module HobbyCatcher
  module Service
    class DeleteAllCourses
      include Dry::Transaction

      step :delete_all_courses

      private

      def delete_all_courses
        courses = delete_from_database
        #news_result = OpenStruct.new(articles: news)

        Success(Response::ApiResult.new(status: :ok, message: courses))
      end

      def delete_from_database
        Repository::For.klass(Entity::Course).delete_all
      end
    end
  end
end