# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'record_representer'

module HobbyCatcher
  module Representer
    # Represents essential Category information for API output
    class RecordList < Roar::Decorator
      include Roar::JSON

      collection :records, extend: Representer::Record
    end
  end
end
