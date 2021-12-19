# frozen_string_literal: true

# :reek:FeatureEnvy
# :reek:UtilityFunction
module HobbyCatcher
  module Entity
    # Aggregate root for suggestions domain
    class HobbySuggestions < SimpleDelegator
      attr_reader :answers

      def initialize(answers:)
        @answers = hobby_type(answers)
      end

      def hobby_type(ans)
        ans.any?(&:nil?) ? nil : to_hobby(Value::PersonalityTrait.new(ans[0], ans[1], ans[2], ans[3]).symbol)
      end

      def to_hobby(animal)
        hobby = HobbyCatcher::Database::HobbyOrm.find(name: animal.upcase)
        HobbyCatcher::Database::RecordOrm.create(hobby_id: hobby.id)
        hobby.update(user_num: hobby.user_num + 1)
      end
    end
  end
end
