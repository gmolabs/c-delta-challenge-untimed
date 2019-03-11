# frozen_string_literal: true

class QuestionChoice < ApplicationRecord
  belongs_to :question, inverse_of: :question_choices
  belongs_to :creative_quality, inverse_of: :question_choices

  has_many :answers
  has_many :survey_responses, through: :answers

  validates :text, :question, :creative_quality, presence: true
  validates :score, numericality: { only_integer: true }

  def score_for(quality)
    quality == creative_quality ? score : 0
  end
end
