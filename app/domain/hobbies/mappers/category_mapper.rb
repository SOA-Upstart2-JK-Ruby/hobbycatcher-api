# frozen_string_literal: false

require_relative 'course_mapper'

module HobbyCatcher
  module Udemy
    # Data Mapper: Udemy category -> Category entity
    # :reek:UtilityFunction
    class CategoryMapper
      def initialize(ud_token, gateway_class = Udemy::Api)
        @token = ud_token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def find(field, keyword)
        data = @gateway.course(field, keyword)
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data['results']
          category_name = @data[0]['primary_subcategory']['title']
          category = HobbyCatcher::Database::CategoryOrm.where(name: category_name).first
          @category = category.to_hash
        end

        def build_entity
          HobbyCatcher::Entity::Category.new(
            id:             nil,
            ud_category_id: ud_category_id,
            name:           name,
            courses:        courses
          )
        end

        private

        def ud_category_id
          @category[:ud_category_id]
        end

        def name
          @category[:name]
        end

        def courses
          @data.map do |course|
            CourseMapper.build_entity(course)
          end
        end
      end
    end
  end
end
