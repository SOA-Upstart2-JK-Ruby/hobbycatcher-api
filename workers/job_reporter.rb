# frozen_string_literal: true

require_relative 'progress_publisher'

module CoursesGet
  # Reports job progress to client
  class JobReporter
     attr_accessor :category

    def initialize(request_json, config)
      
      clone_request = HobbyCatcher::Representer::CloneRequest
        .new(OpenStruct.new)
        .from_json(request_json)
       
      # HobbyCatcher::Udemy::CategoryMapper.new(HobbyCatcher::App.config.UDEMY_TOKEN).find('subcategory', clone_request.category.name)

      @category = clone_request.category
      @publisher = ProgressPublisher.new(config, clone_request.id)
    end

    def report(msg)
      @publisher.publish msg
    end

    def report_each_second(seconds, &operation)
      seconds.times do
        sleep(1)
        report(operation.call)
      end
    end
  end
end