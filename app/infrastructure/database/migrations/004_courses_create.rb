# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:courses) do
      primary_key :id
      foreign_key :owncategory_id, :categories

      Integer  :ud_course_id, unique: true
      String   :title, unique: true, null: false
      String   :url, unique: true, null: false
      String   :image
      String   :ud_category, null: false
      String   :price
      Float    :rating
      Integer  :video_length

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
