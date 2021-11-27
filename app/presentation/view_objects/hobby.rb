# frozen_string_literal: true

require_relative 'category'

module Views
  # View for a single hobby entity
  class Hobby
    def initialize(hobby, index = nil)
      @hobby = hobby
      @index = index
    end

    def entity
      @hobby
    end

    def id
      @hobby.id
    end

    def index_str
      "hobby[#{@index}]"
    end

    def name
      @hobby.name
    end

    def img
      @hobby.img
    end

    def user_num
      @hobby.user_num
    end

    def description
      @hobby.description
    end

    def time
      @hobby.updated_at
    end

    def standard_time
      time.strftime("%F %R")
    end

    def result_url
      "/suggestion/#{@hobby.id}"
    end

    def categories
      @hobby.owned_categories.map { |category| Category.new(category)}
    end

    def categories_each
      categories.each do |category|
        yield category
      end
    end

    def categories_any?
      categories.any?
    end
  end
end
