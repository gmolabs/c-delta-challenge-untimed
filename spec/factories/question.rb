# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { "#{Faker::Hipster.sentence}?" }
  end
end
