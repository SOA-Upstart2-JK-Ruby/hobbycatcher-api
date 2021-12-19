# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative 'hobby'

module HobbyCatcher
  module Entity
    # Domain entity for record
    class Record < Dry::Struct
      include Dry.Types

      attribute :id,          Integer.optional
      attribute :hobby_id,    Hobby
      attribute :updated_at,  Strict::Time

      def to_attr_hash
        to_hash.reject { |key, _| %i[id hobby_id].include? key }
      end
    end
  end
end
