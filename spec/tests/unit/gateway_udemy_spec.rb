# frozen_string_literal: true

require 'set'

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'
require 'rack/test'

describe 'Tests Udemy API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<UDEMY_TOKEN>') { UDEMY_TOKEN }
    c.filter_sensitive_data('<UDEMY_TOKEN_ESC>') { CGI.escape(UDEMY_TOKEN) }
  end

  before do
    VCR.insert_cassette CASSETTE_UD_FILE,
                        record:            :new_episodes,
                        match_requests_on: %i[method uri headers]
    @category = HobbyCatcher::Udemy::CategoryMapper.new(UDEMY_TOKEN).find(FIELD, KEYWORD)
  end

  after do
    VCR.eject_cassette
  end

  describe 'Course API' do
    it 'HAPPY: should provide courses' do
      _(@category.courses).wont_be_nil
    end

    # it 'SAD: should raise exception on incorrect course' do
    #   _(proc do
    #     HobbyCatcher::Udemy::CourselistMapper.new(UDEMY_TOKEN).find('wrongfield', 'wrongkeyword')
    #   end).must_raise HobbyCatcher::Udemy::Api::Response::NotFound
    # end

    it 'SAD: should raise exception when unauthorized' do
      _(proc do
        HobbyCatcher::Udemy::CategoryMapper.new('WrongToken').find(FIELD, KEYWORD)
      end).must_raise HobbyCatcher::Udemy::Api::Response::Forbidden
    end
  end

  describe 'Course Infomation' do
    it 'HAPPY: should provide correct course attributes' do
      # 5.times { sleep(1) and print('.') }
      courses = @category.courses

      _(courses.count).must_equal CORRECT_UD.count

      # # course_id
      # ids = courses.map(&:ud_course_id)
      # correct_ids = CORRECT_UD.map { |c| c['id'] }
      # # _(ids.sort).must_equal correct_ids.sort
      # assert_equal ids.to_set, correct_ids.to_set

      # # title
      # titles = courses.map(&:title)
      # correct_titles = CORRECT_UD.map { |c| c['title'] }
      # # _(titles.sort).must_equal correct_titles.sort
      # assert_equal titles.to_set, correct_titles.to_set

      # # url
      # urls = courses.map(&:url)
      # correct_urls = CORRECT_UD.map { |c| c['url'] }
      # # _(urls.sort).must_equal correct_urls.sort
      # assert_equal urls.to_set, correct_urls.to_set

      # # price
      # prices = courses.map(&:price)
      # correct_prices = CORRECT_UD.map { |c| c['price'] }
      # # _(prices.sort).must_equal correct_prices.sort
      # assert_equal prices.to_set, correct_prices.to_set

      # # image
      # images = courses.map(&:image)
      # correct_images = CORRECT_UD.map { |c| c['image'] }
      # # _(images.sort_by(&:length)).must_equal correct_images.sort_by(&:length)
      # assert_equal images.to_set, correct_images.to_set

      # # rating
      # ratings = courses.map(&:rating)
      # correct_ratings = CORRECT_UD.map { |c| c['rating'] }
      # # _(ratings.sort).must_equal correct_ratings.sort
      # assert_equal ratings.to_set, correct_ratings.to_set

      # category
      categories = courses.map(&:ud_category)
      correct_categories = CORRECT_UD.map { |c| c['category'] }
      # _(categories).must_equal correct_categories
      assert_equal categories.to_set, correct_categories.to_set
    end
  end
end
