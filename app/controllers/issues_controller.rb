class IssuesController < ApplicationController 
  before_action :authenticate_user!

  def index
    @issues = Issue.all
    respond_to do |f|
      f.html 
      f.json {render json: @issues}
    end
  end 
end
