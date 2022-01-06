# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'category_representer'

# Represents essential Repo information for API output
module HobbyCatcher
  module Representer
    # Representer object for project clone requests
    class CloneRequest < Roar::Decorator
      include Roar::JSON

      property :category, extend: Representer::Category, class: OpenStruct
      property :id
    end
  end
end
