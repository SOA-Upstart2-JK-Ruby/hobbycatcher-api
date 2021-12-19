# frozen_string_literal: true

require 'dry/monads'
# :reek:NestedIterators
# :reek:TooManyStatements
# :reek:NilCheck
# :reek:DuplicateMethodCall
module HobbyCatcher
  module Service
    # Retrieves array of all listed hobby entities
    class ShowSuggestion
      include Dry::Monads[:result]

      DB_ERR = 'Having trouble accessing the database'
      PROCESSING_MSG = 'catching udemy course'

      # rubocop:disable Metrics/AbcSize
      def call(input)
        hobby = Repository::Hobbies.find_id(input)

        hobby.categories.each do |category|
          # list = Udemy::CategoryMapper.new(App.config.UDEMY_TOKEN).find('subcategory', category.name)
          # Repository::For.entity(list).update_courses(list) if category.courses.empty?

          Messaging::Queue.new(App.config.CLONE_QUEUE_URL, App.config).send(Representer::Category.new(category).to_json)

          Failure(Response::ApiResult.new(status: :processing, message: PROCESSING_MSG))
        end
        hobby = Repository::Hobbies.find_id(input)

        Success(Response::ApiResult.new(status: :created, message: hobby))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
