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
      expect(my_creative_quality.max_score(questions: [foo_question, bar_question])).to eq(40)
      expect(bar_quality.max_score(questions: [foo_question, bar_question])).to eq(10)
    end
  end

  describe '#normalized_score' do
    let(:my_creative_quality) { build(:creative_quality) }
    it 'should return the normalized score for this creative quality' do
      expect(my_creative_quality.normalized_score(my_raw: 0, my_max: 100)).to eq(0)
      expect(my_creative_quality.normalized_score(my_raw: 100, my_max: 100)).to eq(100)
      expect(my_creative_quality.normalized_score(my_raw: -100, my_max: 100)).to eq(-100)
      expect(my_creative_quality.normalized_score(my_raw: -50, my_max: 100)).to eq(-50)
    end
    it 'should clamp to (-100 to 100) range' do
      expect(my_creative_quality.normalized_score(my_raw: -200, my_max: 100)).to eq(-100)
      expect(my_creative_quality.normalized_score(my_raw: 200, my_max: 100)).to eq(100)
    end
  end

  describe '#raw_total' do
    let(:my_creative_quality) { build(:creative_quality) }
    it 'should return the total score across all surveys for this creative quality' do
      foo_survey = build(:survey_response)
      bar_survey = build(:survey_response)
      allow(foo_survey).to receive(:raw_score).and_return 7
      allow(bar_survey).to receive(:raw_score).and_return 100
      expect(my_creative_quality.raw_total(surveys: [foo_survey, bar_survey])).to eq(107)
    end
  end

  describe '#max_total' do
    let(:my_creative_quality) { build(:creative_quality) }
    it 'should return the maximum summed score for this creative quality across all surveys' do
      allow(my_creative_quality).to receive(:max_score).and_return(8)
      expect(my_creative_quality.max_total(n_surveys: 0)).to eq(0)
      expect(my_creative_quality.max_total(n_surveys: 1)).to eq(8)
      expect(my_creative_quality.max_total(n_surveys: 9)).to eq(72)
    end
  end
end
