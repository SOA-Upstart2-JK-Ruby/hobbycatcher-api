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

  describe 'Show Test (Questions)' do
    before do
      # DatabaseHelper.wipe_database
    end

    it 'HAPPY: should return test that are being watched' do
      questions = HobbyCatcher::Repository::Questions.all

      # WHEN: we request all watched test
      result = HobbyCatcher::Service::ShowTest.new.call

      # THEN: we should see our hobby in the resulting list
      _(result.success?).must_equal true
      tests = result.value!
      _(tests.message).must_equal questions
    end
  end
end
