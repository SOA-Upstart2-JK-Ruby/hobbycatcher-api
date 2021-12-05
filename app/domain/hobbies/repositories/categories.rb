# frozen_string_literal: true

require_relative 'courses'

module HobbyCatcher
  module Repository
    # Repository for Categories
    class Categories
      def self.all
        Database::CategoryOrm.all.map { |db_category| rebuild_entity(db_category) }
      end

      def self.find_full_name(ownhobby_name, owncategory_name)
        db_category = Database::CategoryOrm
          .left_join(:hobbies, id: :ownhobby_id)
          .where(hobbyname: ownhobby_name, name: owncategory_name)
          .first
        rebuild_entity(db_category)
      end

      def self.find(entity)
        find_ud_category_id(entity.ud_category_id)
      end

      def self.find_id(id)
        rebuild_entity Database::CategoryOrm.first(id: id)
      end

      def self.find_name(name)
        rebuild_entity Database::CategoryOrm.first(name: name)
      end

      def self.find_ud_category_id(ud_category_id)
        rebuild_entity Database::CategoryOrm.first(ud_category_id: ud_category_id)
      end

      def self.create(entity)
        raise 'Category already exists' if find(entity)

        db_category = PersistCategory.new(entity).call
        rebuild_entity(db_category)
      end

      def self.update_courses(entity)
        raise 'Courses already exists' unless find(entity).courses.empty?

        db_category = PersistCategory.new(entity).call_for_update
        rebuild_entity(db_category)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Category.new(
          id:             db_record.id,
          ud_category_id: db_record.ud_category_id,
          name:           db_record.name,
          courses:        db_record.owned_courses
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_category|
          Categories.rebuild_entity(db_category)
        end
      end

      # Helper class to persist category and its hobby to database
      class PersistCategory
        def initialize(entity)
          @entity = entity
        end

        def create_category
          Database::CategoryOrm.create(@entity.to_attr_hash)
        end

        # def update_category
        #   Database::CategoryOrm.where(@entity.to_attr_hash)
        # end

        def call
          create_category.tap do |db_category|
            @entity.courses.each do |course|
              db_category.add_course(Courses.db_find_or_create(course))
            end
          end
        end

        def call_for_update
          @entity.courses.map do |course|
            Courses.db_find_or_create(course)
          end
          Database::CategoryOrm.where(@entity.to_attr_hash).first
        end
      end

      def self.db_find_or_create(entity)
        Database::CategoryOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
