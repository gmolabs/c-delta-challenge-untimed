# frozen_string_literal: true

class CreativeQuality < ApplicationRecord
  has_many :question_choices

  validates :name, :description, :color, presence: true

  def max_score(questions = nil)
    questions.nil? ? questions = Question.all : questions
    questions.sum { |q| q.max_for(self) }
  end

  def normalized_score(my_raw = nil, my_max = nil)
    my_raw.nil? ? my_raw = raw_total : my_raw
    my_max.nil? ? my_max = max_total : my_max
    (my_raw.fdiv(my_max) * 100.0).to_i.clamp(-100, 100)
  end

  def raw_total(surveys = nil)
    surveys.nil? ? surveys = SurveyResponse.includes(answers: :question_choice).all : surveys
    surveys.sum { |survey| survey.raw_score(self) }
  end

  def max_total(n_surveys = nil)
    n_surveys.nil? ? n_surveys = SurveyResponse.count : n_surveys
    max_score * n_surveys
  end
end
