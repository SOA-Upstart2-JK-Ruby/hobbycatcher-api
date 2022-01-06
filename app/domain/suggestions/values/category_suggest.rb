# frozen_string_literal: true

# rubocop:disable Style/Documentation
# rubocop:disable Style/SingleLineMethods
module HobbyCatcher
  module Value
    module CategorySuggest
      # Methods of Hobby to align categories
      module HobbyMethods
        def initialize
          create_categories_db
          add_user_num
          create_record_db
        end

        def name
          self.class.hobby_name
        end

        def categories
          self.class.const_get(:CATEGORIES)
        end

        def hobby
          Database::HobbyOrm.find(name: name)
        end

        def add_user_num
          hobby.update(user_num: hobby.user_num + 1)
        end

        def create_categories_db
          categories.map do |key, value|
            unless Repository::Categories.find_name(value)
              Database::CategoryOrm.create(ud_category_id: key, name: value, ownhobby_id: hobby.id)
            end
          end
        end

        def create_record_db
          Database::RecordOrm.create(hobby_id: hobby.id)
        end
      end

      class Lion
        include HobbyMethods
        def self.hobby_name() 'LION' end
        CATEGORIES = { 240 => 'Dance' }.freeze
      end

      class Goat
        include HobbyMethods
        def self.hobby_name() 'GOAT' end
        CATEGORIES = { 180 => 'Arts & Crafts', 304 => 'Music Techniques' }.freeze
      end

      class Dog
        include HobbyMethods
        def self.hobby_name() 'DOG' end
        CATEGORIES = { 226 => 'Sports' }.freeze
      end

      class Owl
        include HobbyMethods
        def self.hobby_name() 'OWL' end
        CATEGORIES = { 222 => 'Fitness' }.freeze
      end

      class Zebra
        include HobbyMethods
        def self.hobby_name() 'ZEBRA' end
        CATEGORIES = { 186 => 'Travel' }.freeze
      end

      class Koala
        include HobbyMethods
        def self.hobby_name() 'KOALA' end
        CATEGORIES = { 192 => 'Pet Care & Training' }.freeze
      end

      class Racoon
        include HobbyMethods
        def self.hobby_name() 'RACOON' end
        CATEGORIES = { 230 => 'Yoga' }.freeze
      end

      class Hedgehog
        include HobbyMethods
        def self.hobby_name() 'HEDGEHOG' end
        CATEGORIES = { 242 => 'Meditation' }.freeze
      end

      class Giraffe
        include HobbyMethods
        def self.hobby_name() 'GIRAFFE' end
        CATEGORIES = { 208 => 'Commercial Photography', 122 => 'Fashion Design' }.freeze
      end

      class Cat
        include HobbyMethods
        def self.hobby_name() 'CAT' end
        CATEGORIES = { 557 => 'Esoteric Practices' }.freeze
      end

      class Rabbit
        include HobbyMethods
        def self.hobby_name() 'RABBIT' end
        CATEGORIES = { 548 => 'Money Management Tools', 58 => 'Real Estate' }.freeze
      end

      class Crocodile
        include HobbyMethods
        def self.hobby_name() 'CROCODILE' end
        CATEGORIES = { 188 => 'Gaming' }.freeze
      end

      class Elephant
        include HobbyMethods
        def self.hobby_name() 'ELEPHANT' end
        CATEGORIES = { 184 => 'Beauty & Makeup' }.freeze
      end

      class Turtle
        include HobbyMethods
        def self.hobby_name() 'TURTLE' end
        CATEGORIES = { 182 => 'Food & Beverage' }.freeze
      end

      class Panda
        include HobbyMethods
        def self.hobby_name() 'PANDA' end
        CATEGORIES = { 164 => 'Creativity', 228 => 'Nutrition & Diet' }.freeze
      end

      class Hippo
        include HobbyMethods
        def self.hobby_name() 'HIPPO' end
        CATEGORIES = { 232 => 'Mental Health', 170 => 'Stress Management' }.freeze
      end

      # rubocop:disable Layout/HashAlignment
      HOBBY_TYPE = {
        'lion'      => Lion,
        'goat'      => Goat,
        'dog'       => Dog,
        'owl'       => Owl,
        'zebra'     => Zebra,
        'koala'     => Koala,
        'racoon'    => Racoon,
        'hedgehog'  => Hedgehog,
        'giraffe'   => Giraffe,
        'cat'       => Cat,
        'rabbit'    => Rabbit,
        'crocodile' => Crocodile,
        'elephant'  => Elephant,
        'turtle'    => Turtle,
        'panda'     => Panda,
        'hippo'     => Hippo
      }.freeze

      def self.result(hobby)
        HOBBY_TYPE[hobby]
      end
    end
  end
end
# rubocop:enable Layout/HashAlignment
# rubocop:enable Style/SingleLineMethods
# rubocop:enable Style/Documentation
