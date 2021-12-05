# frozen_string_literal: true

module HobbyCatcher
  module Repository
    # Repository for Question Entities
    class Questions
      def self.all
        Database::QuestionOrm.all.map { |db_course| rebuild_entity(db_course) }
      end

      def self.find_id(id)
        rebuild_entity Database::QuestionOrm.first(id: id)
      end

      def self.find_buttonname(button_name)
        rebuild_entity Database::QuestionOrm.first(button_name: button_name)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Question.new(
          id:          db_record.id,
          description: db_record.description,
          answerA:     db_record.answerA,
          answerB:     db_record.answerB,
          button_name: db_record.button_name
        )
      end

      def self.db_find_or_create(entity)
        Database::QuestionOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
