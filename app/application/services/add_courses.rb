# frozen_string_literal: true

require 'dry/monads'
# :reek:NestedIterators
# :reek:TooManyStatements
# :reek:NilCheck
# :reek:DuplicateMethodCall
module HobbyCatcher
  module Service
    # Retrieves array of all listed hobby entities
    class AddCourses
      include Dry::Monads[:result]

      DB_ERR = 'Having trouble accessing the database'

      def call(input)
        hobby = Repository::Hobbies.find_id(input)

        hobby.categories.each do |category|
          list = Udemy::CategoryMapper.new(App.config.UDEMY_TOKEN).find('subcategory', category.name)
          Repository::For.entity(list).update_courses(list) if category.courses.empty?
        end
        # hobby = Repository::Hobbies.find_id(input)

        Success(Response::ApiResult.new(status: :created, message: hobby))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
      end
    end
  end
end
