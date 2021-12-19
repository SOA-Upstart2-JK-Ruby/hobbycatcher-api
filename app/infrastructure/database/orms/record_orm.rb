# frozen_string_literal: true

module HobbyCatcher
  module Database
    # Object-Relational Mapper for Records
    class RecordOrm < Sequel::Model(:records)
      plugin :timestamps, update_on_create: true
      def self.find_or_create(record_info)
        first(id: record_info[:id]) || create(record_info)
      end
    end
  end
end
