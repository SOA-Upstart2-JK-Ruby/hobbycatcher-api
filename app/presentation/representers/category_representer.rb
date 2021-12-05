# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'course_representer'

module HobbyCatcher
  module Representer
    # Represents essential Category information for API output
    class Category < Roar::Decorator
      include Roar::JSON

      property :name
      collection :courses, extend: Representer::Course, class: OpenStruct
    end
  end
end
