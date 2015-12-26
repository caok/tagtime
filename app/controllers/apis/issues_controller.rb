module Apis
  class IssuesController < BaseController 
    include TagConcern
    before_action :break_tag, only: [:create]

    def index 
      @issues = @user.issues.first(10)
      render file: 'issues/index.json.jbuilder'
    end 

    def create
      tag_params = generate_params
      issue = @user.issues.new(tag_params)

      if issue.save
        data = {id: issue.id, name: issue.user_name, body: issue.body_without_time, time: issue.spend_time}
        render json: { type: "success", message: "created new issue tag!", data: data } and return
      else
        render json: { type: "fail", message: "failed to create issue tag!" } and return
      end
    end
  end
end
