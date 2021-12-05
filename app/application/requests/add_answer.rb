# frozen_string_literal: true

require 'base64'
require 'dry/monads/result'
require 'json'

# :reek:RepeatedConditiona
module HobbyCatcher
  module Request
    # do validation on test
    class AddAnswer
      include Dry::Monads::Result::Mixin

      def initialize(params)
        @params = params
      end

      # Use in API to parse incoming requests
      def call
        Success([@params['type'], @params['difficulty'], @params['freetime'], @params['emotion']])
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status:  :bad_request,
            message: 'Test not found'
          )
        )
      end
    end
  end
end
