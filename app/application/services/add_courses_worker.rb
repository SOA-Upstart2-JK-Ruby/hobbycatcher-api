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
        input = {}
        input[:hobby_id] = []
        1.upto(16) do |i|
            input[:hobby_id].append(i)
        end
        Success(input) 
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Could not get the news from News API.'))
      end

      def get_category(input)

        hobby_ids= input[:hobby_id]
        input[:category]= []

        hobby_ids.each do |hobby_id|
          hobby= Repository::Hobbies.find_id(hobby_id)
          hobby.categories.each do |category|
            # 判斷沒有底下就不執行，但不執行的原因是因為噴了bug
            input[:category].append(category) if category.courses.empty?
          end  
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