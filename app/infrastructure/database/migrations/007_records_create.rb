# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:records) do
      primary_key :id

      Integer  :hobby_id, null: false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
