# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

# Represents essential Repo information for API output
module HobbyCatcher
  module Representer
    # Represent a Project entity as Json
    class Course < Roar::Decorator
      include Roar::JSON
      # include Roar::Hypermedia
      # include Roar::Decorator::HypermediaConsumer

      property :image
      property :url
      property :price
      property :title
      property :rating

      # link :self do
      #     "#{App.config.API_HOST}/api/v1/projects/#{project_name}/#{owner_name}"
      # end

      # private

      # def project_name
      #   represented.name
      # end

      # def owner_name
      #   represented.owner.username
      # end
    end
  end
end
