# frozen_string_literal: true

module HobbyCatcher
  module Repository
    # Repository for Course
    class Courses
      def self.all
        Database::CourseOrm.all.map { |db_course| rebuild_entity(db_course) }
      end

      def self.find_full_name(owncategory_name, course_title)
        db_course = Database::CourseOrm
          .left_join(:categories, id: :owncategory_id)
          .where(name: owncategory_name, title: course_title)
          .first
        rebuild_entity(db_course)
      end

      def self.find(entity)
        find_ud_course_id(entity.ud_course_id)
      end

      def self.find_id(id)
        db_record = Database::CourseOrm.first(id: id)
        rebuild_entity(db_record)
      end

      def self.find_ud_course_id(ud_course_id)
        db_record = Database::CourseOrm.first(ud_course_id: ud_course_id)
        rebuild_entity(db_record)
      end

      def self.create(entity)
        raise 'Course already exists' if find(entity)

        db_course = PersistCourse.new(entity).call
        rebuild_entity(db_course)
      end

      # rubocop:disable Metrics/MethodLength
      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Course.new(
          id:             db_record.id,
          ud_course_id:   db_record.ud_course_id,
          title:          db_record.title,
          url:            db_record.url,
          image:          db_record.image,
          ud_category:    db_record.ud_category,
          price:          db_record.price,
          rating:         db_record.rating,
          owncategory_id: db_record.owncategory_id
        )
      end
      # rubocop:enable Metrics/MethodLength

      def self.rebuild_many(db_records)
        db_records.map do |db_course|
          Courses.rebuild_entity(db_course)
        end
      end

      # Helper class to persist course and its category to database
      class PersistCourse
        def initialize(entity)
          @entity = entity
        end

        def create_course
          Database::CourseOrm.create(@entity.to_attr_hash)
        end

        def call
          owncategory = Categories.db_find_or_create(@entity.owncategory)

          create_course.tap do |db_course|
            db_course.update(owncategory: owncategory)
          end
        end
      end

      def self.db_find_or_create(entity)
        Database::CourseOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
