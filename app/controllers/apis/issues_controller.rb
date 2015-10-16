module Apis
  class IssuesController < BaseController 
    def index 
      @issues = Issue.all
      render file: 'issues/index.json.jbuilder'
    end 
  end
end
