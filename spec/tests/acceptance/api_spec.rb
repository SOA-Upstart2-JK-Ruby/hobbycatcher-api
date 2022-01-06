# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'
require 'rack/test'

def app
  HobbyCatcher::App
end

describe 'Test API routes' do
  include Rack::Test::Methods

  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_udemy
    DatabaseHelper.wipe_database
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Get test questions' do
    it 'should successfully show all test questions' do
      HobbyCatcher::Service::ShowTest.new.call
      get '/api/v1/test'
      _(last_response.status).must_equal 201

      question = JSON.parse last_response.body
      _(question.length).must_equal 4
    end

    # it 'should report error for bad url' do
    #   HobbyCatcher::Service::ShowTest.new.call
    #   binding.pry
    #   get "/api/v1/test/10"
    #   _(last_response.status).must_equal 500
    #   _(JSON.parse(last_response.body)['status']).must_include 'error'
    # end
  end

  describe 'suggestion route' do
    describe 'Post test' do
      it 'should successfully return hobby answer' do
        post 'api/v1/suggestion?type=0&difficulty=1&freetime=1&emotion=1'
        _(last_response.status).must_equal 201

        answer = JSON.parse last_response.body
        _(answer['name']).must_equal ANIMAL
      end
    end
    describe 'Get suggestion information' do
      it 'should successfully return suggestion information' do
        HobbyCatcher::Service::ShowSuggestion.new.call(HOBBY_ID)
        get "api/v1/suggestion/#{HOBBY_ID}"
        5.times { sleep(1); print '.' }
        get "api/v1/suggestion/#{HOBBY_ID}"
        _(last_response.status).must_equal 201

        hobby = JSON.parse last_response.body
        # _(hobby['categories']['name'][courses]).must_equal 'Dance'

        _(hobby['name']).must_equal 'LION'
        _(hobby['categories'][0]['name']).must_equal 'Dance'
        (hobby['categories'][0]['courses']).length.must_equal 12
      end
      # it 'should be report error for an invalid subfolder' do
      #   HobbyCatcher::Service::ShowSuggestion.new.call(HOBBY_ID)

      #   get "api/v1/suggestion/#{HOBBY_ID}/folder"
      #   _(last_response.status).must_equal 404
      #   _(JSON.parse(last_response.body)['status']).must_include 'not'
      # end
      it 'should be report error for an invalid HOBBY ID' do
        HobbyCatcher::Service::ShowSuggestion.new.call(33)

        get 'api/v1/suggestion/33'
        _(last_response.status).must_equal 500
        _(JSON.parse(last_response.body)['status']).must_include 'error'
      end
    end
  end
end
