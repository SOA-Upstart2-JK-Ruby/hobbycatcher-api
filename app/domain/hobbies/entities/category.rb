# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

require_relative 'course'

module HobbyCatcher
  module Entity
    # Domain entity for categories
    class Category < Dry::Struct
      include Dry.Types

      attribute :id,             Integer.optional
      attribute :ud_category_id, Strict::Integer
      attribute :name,           Strict::String
      attribute :courses,        Strict::Array.of(Course)

      def to_attr_hash
        to_hash.reject { |key, _| %i[id courses].include? key }
      end
    end
  end
end
