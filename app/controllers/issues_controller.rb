class IssuesController < ApplicationController 
  include TagConcern

  before_action :break_tag, only: [:create, :update]
  before_action :get_issue, only: [:update, :destroy]
  before_action :authenticate_user!
  before_action :init_week, only: [:index]

  def index
    @issues = current_user.issues.recent

    respond_to do |f|
      f.html 
      f.json
    end
  end 

  def load_more
    session[:week] += 1
    
    start = (session[:week] - 1) * 7
    dates = current_user.more_dates_for_issues(start)
    @issues = current_user.issues.more(dates)
    render file: 'issues/issues'
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
    if @issue.update(generate_params)
      data = {id: @issue.id, name: @issue.user_name, body: @issue.body_without_time, time: @issue.spend_time, happenedAt: @issue.happened_at.strftime("%m/%d"), content: @issue.content, project_name: @issue.project_name, number: @issue.number}
      render json: { type: "success", message: "update issue tag successful!", data: data } and return
    else
      render json: { type: "fail", message: "failed to update issue tag!" }
    end
  end

  def destroy
    if @issue
      @issue.destroy 
      @issues = current_user.issues.more(session[:week])
      render file: 'issues/issues'
    else
      render json: { type: "fail", message: "failed to create issue tag!" } and return
    end
  end

  private
  def get_issue
    @issue = Issue.find_by(id: params[:id]) if params[:id]
  end

  def init_week
    session[:week] = 0
  end
end
