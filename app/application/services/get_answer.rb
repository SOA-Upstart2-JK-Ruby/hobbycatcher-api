# frozen_string_literal: true

require 'dry/transaction'

# :reek:FeatureEnvy
module HobbyCatcher
  module Service
    # Retrieves array of all listed hobby entities
    class GetAnswer
      include Dry::Transaction

      step :validate_answer
      step :retrieve_hobby

      private

      DB_ERR_MSG = 'Having troble accessing the database'

      # Expects answer in input
      def validate_answer(input)
        answer_request = input[:url_request].call
        if answer_request.success?
          Success(input.merge(answer: answer_request.value!))
        else
          Failure(answer_request.failure)
        end
      end

      def retrieve_hobby(input)
        hobby = Mapper::HobbySuggestions.new(input[:answer]).build_entity
        Success(Response::ApiResult.new(status: :created, message: hobby))
      rescue StandardError
        Failure(
          Response::ApiResult.new(status: :internal_error, message: DB_ERR)
        )
      end
    end
  end
end
