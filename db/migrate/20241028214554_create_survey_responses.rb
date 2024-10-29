class CreateSurveyResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_responses do |t|
      t.text :response
      t.references :encryption_key, null: false, foreign_key: true

      t.timestamps
    end
  end
end
