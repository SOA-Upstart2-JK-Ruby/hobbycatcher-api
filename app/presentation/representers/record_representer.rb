# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'hobby_representer'

module HobbyCatcher
  module Representer
    # Represents folder summary about repo's folder
    class Record < Roar::Decorator
      include Roar::JSON

      property :id
      property :hobby_id, extend: Representer::Hobby, class: OpenStruct
      property :updated_at
    end
  end
end
