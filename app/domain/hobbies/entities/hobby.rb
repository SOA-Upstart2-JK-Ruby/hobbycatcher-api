# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

require_relative 'category'
require_relative 'course'

module HobbyCatcher
  module Entity
    # Domain entity for hobby
    class Hobby < Dry::Struct
      include Dry.Types

      attribute :id,          Integer.optional
      attribute :name,        Strict::String
      attribute :img,         Strict::String
      attribute :description, Strict::String
      attribute :user_num,    Strict::Integer
      attribute :categories,  Strict::Array.of(Category)

      def to_attr_hash
        to_hash.reject { |key, _| %i[id categories].include? key }
      end
    end
  end
end
