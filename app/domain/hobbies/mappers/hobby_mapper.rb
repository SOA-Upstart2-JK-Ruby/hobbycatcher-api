# frozen_string_literal: false

module HobbyCatcher
  module Udemy
    # Data Mapper: HobbyOrm -> Hobby
    class HobbyMapper
      def initialize(ud_token, gateway_class = Udemy::Api)
        @token = ud_token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(ownhobby_id)
          hobby = HobbyCatcher::Database::HobbyOrm.where(id: ownhobby_id).first
          @categories = hobby.owned_categories.map(&:to_hash)
          @hobby = hobby.to_hash
        end

        def build_entity
          Entity::Hobby.new(
            id:          nil,
            name:        name,
            img:         img,
            description: description,
            user_num:    user_num,
            categories:  categories
          )
        end

        private

        def name
          @hobby[:name]
        end

        def img
          @hobby[:img]
        end

        def description
          @hobby[:description]
        end

        def user_num
          @hobby[:user_num]
        end

        def categories
          @categories.map do |category|
            CategoryMapper.build_entity(category[:name])
          end
        end
      end
    end
  end
end
