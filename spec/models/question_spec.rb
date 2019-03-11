# frozen_string_literal: true

require 'rails_helper'

describe Question do
  context 'associations' do
    it { is_expected.to have_many(:question_choices) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :title }
  end

  describe '#max_for' do
    let(:my_creative_quality) { build(:creative_quality) }
    let(:bar_quality) { build(:creative_quality) }
    let(:my_question) { build(:question) }
    it 'should return the maximum score for a given CreativeQuality for this question' do
      foo_question_choice_one = build(:question_choice, score: -2, creative_quality: my_creative_quality)
      foo_question_choice_two = build(:question_choice, score: 0, creative_quality: my_creative_quality)
      foo_question_choice_three = build(:question_choice, score: 2, creative_quality: my_creative_quality)
      foo_question_choice_four = build(:question_choice, score: 5, creative_quality: bar_quality)
      allow(my_question).to receive(:question_choices).and_return([foo_question_choice_one,
                                                                   foo_question_choice_two,
                                                                   foo_question_choice_three,
                                                                   foo_question_choice_four])
      expect(my_question.max_for(my_creative_quality)).to eq(2)
      expect(my_question.max_for(bar_quality)).to eq(5)
    end
  end
end
