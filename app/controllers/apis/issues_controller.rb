module Apis
  class IssuesController < BaseController 
    def index 
      @issues = Issue.all.last(10)
      render file: 'issues/index.json.jbuilder'
    end 

    def create
      issue =  Issue.new(spend_hour: 1, spend_minutes: 30)
      if issue.save
        render json: { type: "success", message: "created new issue tag!" }
      else
        render json: { type: "fail", message: "failed to create issue tag!" }
      end
    end
  end
end
