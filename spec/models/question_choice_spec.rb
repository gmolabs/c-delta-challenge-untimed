# frozen_string_literal: true

require 'rails_helper'

describe QuestionChoice do
  context 'associations' do
    it { is_expected.to belong_to(:question) }
    it { is_expected.to belong_to(:creative_quality) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :text }
    it { is_expected.to validate_presence_of :question }
    it { is_expected.to validate_presence_of :creative_quality }
    it { is_expected.to validate_numericality_of :score }

    describe '#score_for' do
      it 'should return the score if creative_quality matches input' do
        foo_quality = build(:creative_quality)
        bar_quality = build(:creative_quality)
        foo_question_choice = build(:question_choice, score: 2, creative_quality: foo_quality)
        bar_question_choice = build(:question_choice, score: 2, creative_quality: bar_quality)
        expect(foo_question_choice.score_for(foo_quality)).to eq(2)
        expect(foo_question_choice.score_for(bar_quality)).to eq(0)
        expect(bar_question_choice.score_for(foo_quality)).to eq(0)
        expect(bar_question_choice.score_for(bar_quality)).to eq(2)
      end
    end
  end
end
