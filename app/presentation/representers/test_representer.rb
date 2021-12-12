# frozen_string_literal: true

require 'roar/decorator'
require 'representable/json/collection'
require 'roar/json'


module HobbyCatcher
  module Representer
    # Represents test information about test page
    class Test < Roar::Decorator
      include Representable::JSON::Collection
      # include Roar::JSON

      # property :description
      # property :answerA
      # property :answerB
      # property :button_name
      items class: Question do
        property :description
        property :answerA
        property :answerB
        property :button_name
      end

      # collection_representer class: Question
      # collection :Question, extend: Representer::Question, class: OpenStruct
    end
  end
end
