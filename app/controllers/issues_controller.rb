class IssuesController < ApplicationController 
  def index
    @issues = Issue.all
    render file: 'issues/index.json.jbuilder'
  end 
end
