# frozen_string_literal: true

require_relative '../init'
# require_relative '../app/domain/init'
# require_relative '../app/application/requests/init'
# # require_relative '../app/infrastructure/git/init'
# require_relative '../app/presentation/representers/init'
require_relative 'get_monitor'
require_relative 'job_reporter'

require 'figaro'
require 'shoryuken'

# Shoryuken worker class to clone repos in parallel
module CoursesGet
  class Worker
    # Environment variables setup
    
    Figaro.application = Figaro::Application.new(
      environment: ENV['RACK_ENV'] || 'development',
      path:        File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config() = Figaro.env
    

    Shoryuken.sqs_client = Aws::SQS::Client.new(
      access_key_id:     config.AWS_ACCESS_KEY_ID,
      secret_access_key: config.AWS_SECRET_ACCESS_KEY,
      region:            config.AWS_REGION
    )

    include Shoryuken::Worker
    Shoryuken.sqs_client_receive_message_opts = { wait_time_seconds: 20 }
    shoryuken_options queue: config.CLONE_QUEUE_URL, auto_delete: true

    def perform(_sqs_msg, request)
      
      job = JobReporter.new(request, Worker.config)
      
      job.report(GetMonitor.starting_percent)
      
      list = HobbyCatcher::Udemy::CategoryMapper.new(Worker.config.UDEMY_TOKEN).find('subcategory', job.category.name) do |line|
        puts "甚麼軌#{line}"
        job.report GetMonitor.progress(line)
      end

      # CodePraise::GitRepo.new(job.project, Worker.config).clone_locally do |line|
      #   job.report CloneMonitor.progress(line)
      # end
      # binding.pry
      # Keep sending finished status to any latecoming subscribers
      #job.report_each_second(5) { GetMonitor.finished_percent }
      
      # list = HobbyCatcher::Udemy::CategoryMapper.new(HobbyCatcher::App.config.UDEMY_TOKEN).find('subcategory', data.name)

      HobbyCatcher::Repository::For.entity(list).update_courses(list) if job.category.courses.empty?
      job.report(GetMonitor.finished_percent)
    rescue StandardError
      puts 'COURSE EXISTS??? -- ignoring request'
    end
  end
end
