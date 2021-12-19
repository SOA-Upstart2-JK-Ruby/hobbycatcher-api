# frozen_string_literal: true

require_relative 'hobbies'

module HobbyCatcher
  module Repository
    # Repository for Record Entities
    class Records
      def self.find_id(id)
        rebuild_entity Database::RecordOrm.first(id: id)
      end

      def self.find_ids(records)
        records.map do |record|
          find_hobbyid(record)
        end
      end

      def self.find_hobbyid(hobby_id)
        rebuild_entity Database::RecordOrm.first(hobby_id: hobby_id)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Record.new(
          id:          db_record.id,
          hobby_id:    Hobbies.find_id(db_record.hobby_id),
          updated_at:  db_record.updated_at,
        )
      end

      def self.db_find_or_create(entity)
        Database::RecordOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
