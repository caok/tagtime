module Apis
  class IssuesController < BaseController 
    include TagConcern
    before_action :break_tag, only: [:create]

    def index 
      @issues = @user.issues.recent.first(10)
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

    # get time for number by project
    def timelist
      project = @user.projects.where(name: params[:project].try(:downcase)).try(:first)
      spend_hour_hash = Issue.where(project_id: project.id).group(:number).sum(:spend_hour)
      spend_minutes_hash = Issue.where(project_id: project.id).group(:number).sum(:spend_minutes)

      timelist = []
      spend_hour_hash.keys.each do |number|
        str = ''
        spend_hour = spend_hour_hash[number]
        str += "#{spend_hour}h " if spend_hour > 0
        spend_minutes = spend_minutes_hash[number]
        str += "#{spend_minutes}m" if spend_minutes > 0
        str = '0' if str.blank?

        timelist << {number: number, time: str}
      end
      render json: { type: "success", data: timelist}
    end
  end
end
