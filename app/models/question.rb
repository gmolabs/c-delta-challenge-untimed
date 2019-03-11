# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :question_choices, inverse_of: :question

  validates :title, presence: true

  accepts_nested_attributes_for(:question_choices)
end
