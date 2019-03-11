# frozen_string_literal: true

class CreativeQuality < ApplicationRecord
  has_many :question_choices

  validates :name, :description, :color, presence: true

  def max_score(questions: nil)
    questions.nil? ? questions = Question.all : questions
    questions.sum { |q| q.max_for(self) }
  end


end
