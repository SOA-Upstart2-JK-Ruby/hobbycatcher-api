# frozen_string_literal: false

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'Integration Tests of Udemy API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_udemy
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
       DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save project from Udemy to database' do
      category = HobbyCatcher::Udemy::CategoryMapper.new(UDEMY_TOKEN)
        .find(FIELD, KEYWORD)
      rebuilt = HobbyCatcher::Repository::For.entity(category).update_courses(category)

      courses = category.courses
      rebuilt_courses= rebuilt.courses
      (courses.length).must_equal rebuilt_courses.length
     
      # courses.map do |course|
      #   rebuilt = HobbyCatcher::Repository::For.entity(course).create(course)
      #   _(rebuilt[:ud_course_id]).must_equal(course[:ud_course_id])
      #   _(rebuilt[:title]).must_equal(course[:title])
      #   _(rebuilt[:url]).must_equal(course[:url])
      #   _(rebuilt[:price]).must_equal(course[:price])
      #   _(rebuilt[:image]).must_equal(course[:image])
      #   _(rebuilt[:rating]).must_equal(course[:rating])
      #   _(rebuilt[:ud_category]).must_equal(course[:ud_category])
      # end
    end
  end
end
