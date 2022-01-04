# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module HobbyCatcher
  module Services
    class AddCoursesWorker
      include Dry::Transaction

      step :get_category
      step :get_courses_from_api
      step :store_courses_in_database


      private

      def get_category(input)
        hobby = Repository::Hobbies.find_id(input[:hobby_id])
        hobby.categories.each do |category|
          input[:category].append(category)
        end
        Success(input)
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Could not get the news from News API.'))
      end

      def get_courses_from_api(input)
        categories = input[:category]
        categories.each do |category|
          input[:list] = Udemy::CategoryMapper
            .new(Worker.config.UDEMY_TOKEN)
            .find('subcategory',category)
        end
        Success(Response::ApiResult.new(status: :ok, message: 'Succeed'))
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :internal_error, message: e.message))
      end

      def store_courses_in_database(input)
        courses = input[:list]
        courses.each do |course|
          Repository::For.entity(course).update_courses(course) if course.category.courses.empty?
        end
        Success(Response::ApiResult.new(status: :ok, message: 'Succeed'))
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :internal_error, message: e.message))
      end
    end
  end
end
