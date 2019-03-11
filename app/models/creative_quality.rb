# frozen_string_literal: true

class CreativeQuality < ApplicationRecord
  has_many :question_choices

  validates :name, :description, :color, presence: true

  def max_score(questions = nil)
    questions.nil? ? questions = Question.all : questions
    questions.sum { |q| q.max_for(self) }
  end

  def normalized_score(my_raw = raw_total, my_max = max_total)
    (my_raw.fdiv(my_max) * 100.0).to_i.clamp(-100, 100)
  end
end
