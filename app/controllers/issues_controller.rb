class IssuesController < ApplicationController 
  include TagConcern
  before_action :break_tag, only: [:create]
  before_action :authenticate_user!

  def index
    @issues = current_user.issues.first(20)

    respond_to do |f|
      f.html 
      f.json
    end
  end 

  def create
    tag_params = generate_params
    issue = current_user.issues.new(tag_params)

    if issue.save
      data = {id: issue.id, name: issue.user_name, body: issue.body_without_time, time: issue.spend_time}
      render json: { type: "success", message: "created new issue tag!", data: data } and return
    else
      render json: { type: "fail", message: "failed to create issue tag!" } and return
    end
  end
end
