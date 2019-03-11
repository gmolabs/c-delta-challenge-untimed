# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :question_choices, inverse_of: :question

  validates :title, presence: true

  accepts_nested_attributes_for(:question_choices)

  def max_for(quality)
    question_choices.max_by { |choice| choice.score_for(quality) }
                    .score_for(quality)
  end
end
