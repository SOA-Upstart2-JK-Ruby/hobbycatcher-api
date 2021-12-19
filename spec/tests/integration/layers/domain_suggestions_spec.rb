# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'Test TEST reply and work correctly' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_udemy
    DatabaseHelper.wipe_database
  end

  after do
    VcrHelper.eject_vcr
  end

  it 'HAPPY: should get hobby suggesstions from answers' do
    suggestion = HobbyCatcher::Mapper::HobbySuggestions.new(CORRECT_ANSWERS).build_entity

    _(suggestion).wont_be_nil
    _(suggestion.class).must_equal HobbyCatcher::Entity::HobbySuggestions

    _(suggestion.answers.name).must_equal ANIMAL
  end
end
