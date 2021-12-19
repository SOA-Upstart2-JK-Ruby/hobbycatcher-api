# frozen_string_literal: true

require_relative 'hobbies'
require_relative 'categories'
require_relative 'courses'
require_relative 'records'

module HobbyCatcher
  module Repository
    # Finds the right repository for an entity object or class
    module For
      ENTITY_REPOSITORY = {
        Entity::Hobby => Hobbies,
        Entity::Category => Categories,
        Entity::Course => Courses,
        Entity::Record => Records
      }.freeze

      def self.klass(entity_klass)
        ENTITY_REPOSITORY[entity_klass]
      end

      def self.entity(entity_object)
        ENTITY_REPOSITORY[entity_object.class]
      end
    end
  end
end
