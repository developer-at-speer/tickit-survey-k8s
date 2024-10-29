class SurveyQuestionsController < ApplicationController
  @@data = File.read("#{Rails.root}/public/data.json")
  def index
    render :json => @@data
  end
end