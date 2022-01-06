# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'category_representer'

module HobbyCatcher
  module Representer
    # Represents folder summary about repo's folder
    class Suggestion < Roar::Decorator
      include Roar::JSON

      property :name
      property :img
      property :description
      property :updated_at

      collection :categories, extend: Representer::Category, class: OpenStruct
    end
  end
end
