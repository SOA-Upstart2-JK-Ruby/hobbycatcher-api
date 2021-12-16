# frozen_string_literal: true

require_relative '../init'

require 'figaro'
require 'shoryuken'

# Shoryuken worker class to clone repos in parallel
class CoursesGetWorker
  # Environment variables setup
  Figaro.application = Figaro::Application.new(
    environment: ENV['RACK_ENV'] || 'development',
    path: File.expand_path('config/secrets.yml')
  )
  Figaro.load
  def self.config() = Figaro.env

  Shoryuken.sqs_client = Aws::SQS::Client.new(
    access_key_id: config.AWS_ACCESS_KEY_ID,
    secret_access_key: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION
  )

  include Shoryuken::Worker
  shoryuken_options queue: config.CLONE_QUEUE_URL, auto_delete: true

  def perform(_sqs_msg, request)
    # course = HobbyCatcher::Representer::Course
    #   .new(OpenStruct.new).from_json(request)
    # CodePraise::GitRepo.new(project).clone
   # binding.pry
    data = HobbyCatcher::Representer::Category.new(OpenStruct.new).from_json(request)
    list = HobbyCatcher::Udemy::CategoryMapper.new(HobbyCatcher::App.config.UDEMY_TOKEN).find('subcategory',data.name)

    HobbyCatcher::Repository::For.entity(list).update_courses(list) if data.courses.empty?
  rescue StandardError
    puts 'COURSE EXISTS??? -- ignoring request'
  end
end
