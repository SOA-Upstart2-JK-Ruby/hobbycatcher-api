# frozen_string_literal: true

require 'roda'

# :reek:RepeatedConditiona
module HobbyCatcher
  # Web App
  class App < Roda
    plugin :halt
    plugin :caching
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs

    # rubocop:disable Metrics/BlockLength
    route do |routing|
      response['Content-Type'] = 'application/json'

      # GET /
      routing.root do
        message = "HobbyCatcher API v1 at /api/v1/ in #{App.environment} mode"

        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api/v1' do
        routing.on 'test' do
          # GET api/v1/test
          routing.get do
            response.cache_control public: true, max_age: 300

            result = Service::ShowTest.new.call

            if result.failure?
              failed = Representer::HttpResponse.new(result.failure)
              routing.halt failed.http_status_code, failed.to_json
            end

            http_response = Representer::HttpResponse.new(result.value!)
            response.status = http_response.http_status_code
            Representer::Test.new(result.value!.message).to_json
          end
        end

        routing.on 'suggestion' do
          routing.is do
            # POST api/v1/suggestion?S1
            routing.post do
              url_req = Request::AddAnswer.new(routing.params)
              result = Service::GetAnswer.new.call(url_request: url_req)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Representer::Hobby.new(result.value!.message.answers).to_json
            end
          end

          routing.on String do |hobby_id|
            # GET api/v1/suggestion/{hobby_id}
            routing.get do
              response.cache_control public: true, max_age: 300
              
              request_id = [request.env, request.path, Time.now.to_f].hash

              result = Service::ShowSuggestion.new.call(
                requested: hobby_id,
                request_id: request_id,
                config: App.config
              )

              # result = Service::ShowSuggestion.new.call(hobby_id)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              Representer::Suggestion.new(result.value!.message).to_json
            end
          end
        end

        routing.on 'history' do
          # GET api/v1/history?list={base64_json_array_of_records}
          routing.get do
            # Bug: Search hobby_id
            list_req = Request::EncodedRecordList.new(routing.params)
            result = Service::ListHistories.new.call(list_request: list_req)

            if result.failure?
              failed = Representer::HttpResponse.new(result.failure)
              routing.halt failed.http_status_code, failed.to_json
            end

            http_response = Representer::HttpResponse.new(result.value!)
            response.status = http_response.http_status_code
            Representer::RecordList.new(result.value!.message).to_json
          end
        end

        routing.on 'scheduler' do
          # PUT /api/v1/scheduler
          routing.get do
            run_scheduler = Services::ScheduledWorker.new.call

            if run_scheduler.failure?
              failed = Representer::HttpResponse.new(run_scheduler.failure)
              routing.halt failed.http_status_code, failed.to_json
            end
            http_response = Representer::HttpResponse.new(run_scheduler.value!)
            response.status = http_response.http_status_code

            { message: 'Scheduler Succeeded' }.to_json
          rescue StandardError => e
            puts e.message
            routing.redirect '/'
          end
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
