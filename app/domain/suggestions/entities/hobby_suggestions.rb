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
        ans.any?(&:nil?) ? nil : Value::PersonalityTrait.new(ans[0], ans[1], ans[2], ans[3]).hobby
      end
    end
  end
end
