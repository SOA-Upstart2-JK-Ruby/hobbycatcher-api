# frozen_string_literal: true

require 'dry/transaction'
require 'base64'
require 'json'

module HobbyCatcher
  module Services
    # Transaction to add recommendations of news and donation projects
    class ScheduledWorker
      include Dry::Transaction

      step :delete_data_in_database
      step :add_hobby_id
      step :add_courses


      private

      def delete_data_in_database
        HobbyCatcher::Services::DeleteAllCourses.new.call
        Success(Response::ApiResult.new(status: :ok, message: 'Succeed to delete data.'))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Fail to delete data in the database.'))
      end

      def add_hobby_id
        input = {}
        input[:hobby_id] = []
        1.upto(18) do |i|
            input[:hobby_id].append(i)
        end
        
        # Success(input)
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Fail to get event names.'))
      end

      def add_courses(input)
        binding.pry
        hobby_ids = input[:hobby_id]
        hobby_ids.each do |hobby_id|
          
          HobbyCatcher::Services::AddCoursesWorker.new.call(hobby_id: hobby_id)
        end
        Success(input)
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Fail to add news in database.'))
      end
    end
  end
end
