# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module HobbyCatcher
  module Service
    class AddCoursesWorker
      include Dry::Transaction

      step :delete_data_in_database
      step :add_hobby_id
      step :get_category
      step :get_courses_from_api
      step :store_courses_in_database


      private

      def delete_data_in_database
        HobbyCatcher::Service::DeleteAllCourses.new.call
        Success(Response::ApiResult.new(status: :ok, message: 'Succeed to delete data.'))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Fail to delete data in the database.'))
      end

      def add_hobby_id
        (0..15).map do |id|
          arr = id.to_s(2).rjust(4, '0').split(//)
          Mapper::HobbySuggestions.new(arr).build_entity
        end

        input = {hobby_id: (1..16).to_a}

        Success(input) 
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Could not get the news from News API.'))
      end

      def get_category(input) 

        input[:category] = Repository::Categories.all.map do |category|
          category if category.courses.empty?
        end

        Success(input) 
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Could not get the news from News API.'))
      end

      def get_courses_from_api(input)
        categories = input[:category]
        input[:list] = []
        categories.each do |category|
          input[:list].append(Udemy::CategoryMapper.new(App.config.UDEMY_TOKEN).find('subcategory',category.name))
        end
        Success(input)
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :internal_error, message: e.message))
      end

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
