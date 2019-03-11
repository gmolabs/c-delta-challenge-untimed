# frozen_string_literal: true

Rails.application.routes.draw do
  resources :questions, only: %i[show index]
  resources :survey_responses, only: %i[show index]
  resources :creative_qualities, only: [:index]

  root to: 'creative_qualities#index'
end
