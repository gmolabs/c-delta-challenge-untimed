# frozen_string_literal: true

class CreateSurveyResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :survey_responses do |t|
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
