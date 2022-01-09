# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

require 'ostruct'

describe 'Show Suggestion Service Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_udemy
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Show Test (Suggestions)' do
    before do
      # DatabaseHelper.wipe_database
    end

    it 'HAPPY: should return suggestion related to test' do
      
       hobby = HobbyCatcher::Repository::Hobbies.find_id(HOBBY_ID)

       categories = HobbyCatcher::Repository::Hobbies.find_owncategories(HOBBY_ID)

      # rebuilt_courses= rebuilt.courses
      #   (courses.length).must_equal rebuilt_courses.length
      # courses = category.courses


      # # courses_intros = []
      # # courses.map do |course_intro|
      # #   course = HobbyCatcher::Repository::For.entity(course_intro)
      # #   course.create(course_intro) if course.find(course_intro).nil?
      # # end
      # # courses_intros.append(courses)

      # WHEN: we request all related data
      result = HobbyCatcher::Service::ShowSuggestion.new.call(HOBBY_ID)

      # THEN: we should see data in the suggestion page
      _(result.success?).must_equal true
      tests = result.value!.message
     
      _(tests.name).must_equal hobby.name
      _(tests.categories[0].name).must_equal categories[0].name
       _( tests.categories[0].courses.length).must_equal 12
    end
  end
end
