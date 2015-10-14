module Apis
  class IssuesController < BaseController 
    def index 
      @issues = Issue.all
    end 
  end
end
