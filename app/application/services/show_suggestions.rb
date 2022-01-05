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

      # rubocop:disable Metrics/AbcSize
      def call(input)

        hobby = Repository::Hobbies.find_id(input)

        Success(Response::ApiResult.new(status: :created, message: hobby))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
