class IssuesController < ApplicationController 
  include TagConcern

  before_action :break_tag, only: [:create, :update]
  before_action :get_issue, only: [:update, :destroy]
  before_action :authenticate_user!

  def index
    @issues = current_user.issues.recent.first(20)

    respond_to do |f|
      f.html 
      f.json
    end
  end 

  def create
    tag_params = generate_params
    issue = current_user.issues.new(tag_params)

    if issue.save
      data = {id: issue.id, name: issue.user_name, body: issue.body_without_time, time: issue.spend_time, happenedAt: issue.happened_at.strftime("%m/%d"), content: issue.content, project_name: issue.project_name, number: issue.number}
      render json: { type: "success", message: "created new issue tag!", data: data } and return
    else
      render json: { type: "fail", message: "failed to create issue tag!" } and return
    end
  end

  def update
    tag_params = generate_params
    if @issue
      @issue.update(tag_params)
      @issues = current_user.issues.recent.first(20)
      render file: 'issues/issues'
    else
      render json: { type: "fail", message: "failed to update issue tag!" }
    end
  end

  def destroy
    if @issue
      @issue.destroy 
      @issues = current_user.issues.recent.first(20)
      render file: 'issues/issues'
    else
      render json: { type: "fail", message: "failed to create issue tag!" } and return
    end
  end

  private
  def get_issue
    @issue = Issue.find_by(id: params[:id]) if params[:id]
  end
end
