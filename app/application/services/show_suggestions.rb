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

      def call(input)
        hobby = Repository::Hobbies.find_id(input)

        Success(Response::ApiResult.new(status: :created, message: hobby))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
      end

      def clone_request_json(input)
        Response::CloneRequest.new(input[:category], input[:request_id])
          .then { Representer::CloneRequest.new(_1) }
          .then(&:to_json)
      end
    end
  end
end
