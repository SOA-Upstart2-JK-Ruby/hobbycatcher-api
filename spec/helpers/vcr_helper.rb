# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
module VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'
  UDEMY_CASSETTE = 'udemy_api'

  def self.setup_vcr
    VCR.configure do |config|
      config.cassette_library_dir = CASSETTES_FOLDER
      config.hook_into :webmock
      vcr_config.ignore_localhost = true # for acceptance tests
      vcr_config.ignore_hosts 'sqs.us-east-1.amazonaws.com'
      vcr_config.ignore_hosts 'sqs.ap-northeast-1.amazonaws.com'
    end
  end

  def self.configure_vcr_for_udemy
    VCR.configure do |config|
      config.filter_sensitive_data('<UDEMY_TOKEN>') { UDEMY_TOKEN }
      config.filter_sensitive_data('<UDEMY_TOKEN_ESC>') { CGI.escape(UDEMY_TOKEN) }
    end
    VCR.insert_cassette(
      UDEMY_CASSETTE,
      record:            :new_episodes,
      match_requests_on: %i[method uri headers]
    )
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
