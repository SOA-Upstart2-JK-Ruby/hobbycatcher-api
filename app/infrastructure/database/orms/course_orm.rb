# frozen_string_literal: true

require 'sequel'

module HobbyCatcher
  module Database
    # Object-Relational Mapper for Courses
    class CourseOrm < Sequel::Model(:courses)
      many_to_one :owncategory,
                  class: :'HobbyCatcher::Database::CategoryOrm'

      plugin :timestamps, update_on_create: true

      def self.find_or_create(course_info)
        first(title: course_info[:title]) || create(course_info)
      end
    end
  end
end
