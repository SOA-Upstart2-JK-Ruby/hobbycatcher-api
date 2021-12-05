# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module HobbyCatcher
  module Entity
    # Domain entity for courses
    class Course < Dry::Struct
      include Dry.Types

      attribute :id,              Integer.optional
      attribute :ud_course_id,    Strict::Integer
      attribute :title,           Strict::String
      attribute :url,             Strict::String
      attribute :image,           Strict::String
      attribute :ud_category,     Strict::String
      attribute :price,           Strict::String
      attribute :rating,          Strict::Float
      attribute :owncategory_id,  Strict::Integer

      def to_attr_hash
        to_hash.reject { |key, _| %i[id owncategory].include? key }
      end
    end
  end
end
