# frozen_string_literal: true

require 'rails_helper'

describe CreativeQuality do
  context 'associations' do
    it { is_expected.to have_many(:question_choices) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
  end

  describe '#max_score' do
    let(:my_creative_quality) { build(:creative_quality) }
    let(:bar_quality) { build(:creative_quality) }

    it 'should return the maximum score possible for this creative quality' do
      foo_question = build(:question)
      bar_question = build(:question)
      foo_question_choice = build(:question_choice, score: 2, creative_quality: my_creative_quality)
      bar_question_choice = build(:question_choice, score: 2, creative_quality: bar_quality)
      foo_question_choice_two = build(:question_choice, score: 20, creative_quality: my_creative_quality)
      bar_question_choice_two = build(:question_choice, score: 5, creative_quality: bar_quality)
      allow(foo_question).to receive(:question_choices).and_return([foo_question_choice, bar_question_choice, foo_question_choice_two, bar_question_choice_two])
      allow(bar_question).to receive(:question_choices).and_return([foo_question_choice, bar_question_choice, foo_question_choice_two, bar_question_choice_two])
      expect(my_creative_quality.max_score([foo_question, bar_question])).to eq(40)
      expect(bar_quality.max_score([foo_question, bar_question])).to eq(10)
    end
  end
end
