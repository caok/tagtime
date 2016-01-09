class ReportController < ApplicationController
  before_action :authenticate_user!
  before_action :get_date_range

  def summary
    @project_id = params[:project]
    user_ids = params[:project].present? ? params[:users] : [current_user.id]
    get_spend_hour_by_date(user_ids, @project_id, *split_date_range)
    if @project_id.present?
      get_spend_hour_by_users(user_ids, @project_id, *split_date_range)
    else
      get_spend_hour_by_projects(user_ids, *split_date_range)
    end
  end

  def detail
    @project = current_user.projects.find_by(id: params[:project])
    return redirect_to report_summary_path if @project.blank?

    user_ids = params[:users].present? ? params[:users] : @project.users.map(&:id)
    get_spend_hour_by_date(user_ids, @project.id, *split_date_range)
    @issues = @project.filter_issues(user_ids, *split_date_range).order(happened_at: :desc).page params[:page]
  end

  private
  def split_date_range
    start_date, end_date = @date_range.split(" - ")
    [convert_date(start_date).to_datetime, convert_date(end_date).to_datetime]
  end

  def get_date_range
    unless @date_range = params[:date_range]
      @date_range = "#{Time.now.beginning_of_week.to_date.strftime("%m/%d/%Y")} - #{Time.now.end_of_week.to_date.strftime("%m/%d/%Y")}"
    end
  end 

  def convert_date(date)
    m, d, y =  date.split("/")
    "#{d}/#{m}/#{y}"
  end

  def get_spend_hour_by_date(user_ids, project_id=nil, start_date, end_date)
    condition = Issue.where(happened_at: start_date..end_date)
    condition = condition.where(user_id: user_ids) if user_ids.present?
    condition = condition.where(project_id: project_id) if project_id.present?
    spend_hour_hash = condition.group(:happened_at).sum(:spend_hour)
    spend_minute_hash = condition.group(:happened_at).sum(:spend_minutes)

    @report_by_date = []
    (start_date..end_date).each do |date|
      hours = (spend_hour_hash[date].to_f + spend_minute_hash[date].to_f / 60).round(2)
      @report_by_date << [date.to_s(:md), hours]
    end
  end

  def get_spend_hour_by_projects(user_ids, start_date, end_date)
    condition = Issue.where(happened_at: start_date..end_date)
    condition = condition.where(user_id: user_ids) if user_ids.present?
    spend_hour_hash = condition.group(:project_id).sum(:spend_hour)
    spend_minute_hash = condition.group(:project_id).sum(:spend_minutes)

    @reports = []
    @projects_hash = []
    condition.select(:project_id).distinct.map(&:project_id).each do |project_id|
      project = current_user.projects.find_by(id: project_id)
      if project.present?
        hours = (spend_hour_hash[project_id].to_f + spend_minute_hash[project_id].to_f / 60).round(2)
        @reports << [project.name, hours]
        @projects_hash << {name: project.name, id: project.id}
      end
    end
  end

  def get_spend_hour_by_users(user_ids, project_id=nil, start_date, end_date)
    condition = Issue.where(happened_at: start_date..end_date)
    condition = condition.where(user_id: user_ids) if user_ids.present?
    condition = condition.where(project_id: project_id) if project_id.present?
    spend_hour_hash = condition.group(:user_id).sum(:spend_hour)
    spend_minute_hash = condition.group(:user_id).sum(:spend_minutes)

    @reports = []
    condition.select(:user_id).distinct.map(&:user_id).each do |user_id|
      user = User.find_by(id: user_id)
      if user.present?
        hours = (spend_hour_hash[user_id].to_f + spend_minute_hash[user_id].to_f / 60).round(2)
        @reports << [user.name, hours]
      end
    end
  end
end
