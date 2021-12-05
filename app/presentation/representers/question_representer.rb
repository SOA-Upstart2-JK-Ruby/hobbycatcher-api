# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module HobbyCatcher
  module Representer
    # Represents test information about test page
    class Question < Roar::Decorator
      include Roar::JSON
      property :description
      property :answerA
      property :answerB
      property :button_name
    end
  end
end
