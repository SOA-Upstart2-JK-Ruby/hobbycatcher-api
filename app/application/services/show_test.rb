# frozen_string_literal: true

require 'dry/monads'

module HobbyCatcher
  module Service
    # Retrieves array of all listed hobby entities
    class ShowTest
      include Dry::Monads[:result]
      DB_ERR_MSG = 'Having trouble accessing the database'

      def call(input)
        questions = Repository::Questions.find_id(input)
        descriptions = questions.description

        Success(Response::ApiResult.new(status: :created, message: questions))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR_MSG))
      end
    end
  end
end
