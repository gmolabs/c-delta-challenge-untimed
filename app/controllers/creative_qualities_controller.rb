# frozen_string_literal: true

class CreativeQualitiesController < ApplicationController
  include ApplicationHelper
  def index
    @creative_qualities = CreativeQuality.all
    respond_to do |format|
      format.html
      format.json { render json: mock_creative_quality_scores }
    end
  end
end
