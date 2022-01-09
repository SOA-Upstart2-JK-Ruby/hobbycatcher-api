# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

require 'ostruct'

describe 'List History Hobbies Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_udemy
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'List History Hobbies' do
    before do
      # DatabaseHelper.wipe_database
    end

    # it 'HAPPY: should return history that are being watched' do
    #   # GIVEN: a valid hobby exists locally and is being watched
    #   hobby = HobbyCatcher::Database::HobbyOrm
    #     .where(name: ANIMAL).first

    #   watched_list = [hobby]

    #   # WHEN: we request a list of all watched hobby
    #   result = HobbyCatcher::Service::ListHistories.new.call(watched_list)

    #   # THEN: we should see our hobby in the resulting list
    #   _(result.success?).must_equal true
    #   history = result.value!
    #   _(history).must_include hobby
    # end

    # it 'HAPPY: should not return history that are not being watched' do
    #   # GIVEN: a valid hobby exists locally but is not being watched
    #   HobbyCatcher::Database::HobbyOrm.where(name: ANIMAL)
    #   watched_list = []

    #   # WHEN: we request a list of all watched projects
    #   result = HobbyCatcher::Service::ListHistories.new.call(watched_list)

    #   # THEN: it should return an empty list
    #   _(result.success?).must_equal true
    #   history = result.value!
    #   _(history).must_equal []
    # end
  end
end
