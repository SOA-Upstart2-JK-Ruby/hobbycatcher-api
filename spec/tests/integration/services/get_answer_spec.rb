# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

require 'ostruct'

describe 'Show Test Service Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_udemy
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Get Answer Related Data' do
    before do
      # DatabaseHelper.wipe_database
    end

    # it 'HAPPY: should return data related our suggestion logic' do
    #   # hobby = HobbyCatcher::Mapper::HobbySuggestions.new(CORRECT_ANSWERS).build_entity

    #   # WHEN: we request all watched test
    #   suggestion = HobbyCatcher::Mapper::HobbySuggestions.new(CORRECT_ANSWERS).build_entity

    #   result = HobbyCatcher::Service::GetAnswer.new.call(suggestion)
    #   # THEN: we should see our hobby in the resulting list
    #   _(result.success?).must_equal true
    #   # tests = result.value!
    #   # _(tests).must_equal hobby
    # end
  end
end
