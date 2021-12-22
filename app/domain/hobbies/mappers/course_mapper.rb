# frozen_string_literal: false

module HobbyCatcher
  module Udemy
    # Data Mapper: Udemy course -> Course entity
    # :reek:UtilityFunction
    class CourseMapper
      def initialize(ud_token, gateway_class = Udemy::Api)
        @token = ud_token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def find(field, keyword)
        data = @gateway.course(field, keyword)
        DataMapper.new(data).build_entity
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      # rubocop:disable Metrics/MethodLength
      class DataMapper
        def initialize(course)
          @course = course
        end

        def build_entity
          HobbyCatcher::Entity::Course.new(
            id:             nil,
            ud_course_id:   ud_course_id,
            title:          title,
            url:            url,
            image:          image,
            ud_category:    ud_category,
            price:          price,
            rating:         rating,
            video_length:   video_length,
            owncategory_id: owncategory_id
          )
        end

        private

        def ud_course_id
          @course['id']
        end

        def title
          @course['title']
        end

        def url
          "https://www.udemy.com#{@course['url']}"
        end

        def price
          @course['price']
        end

        def image
          @course['image_240x135']
        end

        def rating
          avg_rating = @course['avg_rating']
          avg_rating.zero? ? 0.0 : avg_rating
        end

        def video_length
          length = @course['content_length_video']
          length.zero? ? 0 : length
        end

        def ud_category
          @course['primary_subcategory']['title']
        end

        def owncategory_id
          Database::CategoryOrm.where(name: ud_category).first.id
        end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
