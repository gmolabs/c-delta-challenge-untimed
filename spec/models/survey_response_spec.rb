# frozen_string_literal: true

require 'rails_helper'

describe SurveyResponse do
  context 'associations' do
    it { is_expected.to have_many(:answers) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }
  end

  describe '#display_name' do
    let(:survey_response) { create(:survey_response) }

    it 'concatenates the first and last name' do
      expect(survey_response.display_name).to eql(
        [
          survey_response.first_name,
          survey_response.last_name
        ].join(' ')
      )
    end
  end

  describe '#raw_score' do
    context 'when answers have different qualities and scores' do
      let(:survey_response) { build(:survey_response) }
      it 'should sum all answers\' scores for a given quality in a survey_response' do
        foo_quality = build(:creative_quality)
        foo_answer = double('foo answer')
        foo_answer_two = double('foo answer two')
        foo_answer_three = double('foo answer three')
        bar_answer = double('bar answer')
        allow(foo_answer).to receive(:score_for).with(foo_quality).and_return(3)
        allow(foo_answer_two).to receive(:score_for).with(foo_quality).and_return(2)
        allow(foo_answer_three).to receive(:score_for).with(foo_quality).and_return(-1)
        allow(bar_answer).to receive(:score_for).with(foo_quality).and_return(0)
        expect(survey_response).to receive(:answers).and_return([foo_answer, foo_answer_two, foo_answer_three, bar_answer])
        expect(survey_response.raw_score(foo_quality)).to eq(4)
      end
    end
  end

  describe '#completed?' do
    let(:survey_response) { build(:survey_response) }

    before do
      allow(Question).to receive(:count).and_return(3)
      allow(survey_response).to receive_message_chain(:answers, :count)
        .and_return(survey_response_count)
    end

    context 'when no responses exist' do
      let(:survey_response_count) { 0 }

      it 'is false' do
        expect(survey_response.completed?).to be(false)
      end
    end

    context 'when some responses exist' do
      let(:survey_response_count) { 1 }

      it 'is false' do
        expect(survey_response.completed?).to be(false)
      end
    end

    context 'when responses exist for all questions' do
      let(:survey_response_count) { 3 }

      it 'is true' do
        expect(survey_response.completed?).to be(true)
      end
    end
  end
end
