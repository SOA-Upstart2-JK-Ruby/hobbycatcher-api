# frozen_string_literal: true

require 'dry/monads'

module HobbyCatcher
  module Service
    # Retrieves array of all listed hobby entities
    class ShowTest
      include Dry::Monads[:result]
      DB_ERR_MSG = 'Having trouble accessing the database'

      def call
        questions = Repository::Questions.all
        Success(Response::ApiResult.new(status: :created, message: questions))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR_MSG))
      end
    end
  end
end
