# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module HobbyCatcher
  module Representer
    # Represents folder summary about repo's folder
    class Hobby < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :id
      property :name
      property :img
      property :description
      property :user_num

      link :self do
        "#{App.config.API_HOST}/api/v1/suggestion/#{hobby_id}"
      end

      private

      def hobby_id
        represented.id
      end
    end
  end
end
