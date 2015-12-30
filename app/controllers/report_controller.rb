class ReportController < ApplicationController
  before_action :authenticate_user!
  before_action :get_date_range

  def summary
    get_spend_hour_by_date(current_user, *split_date_range)
    get_spend_hour_by_project(current_user, *split_date_range)
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

  def get_spend_hour_by_date(user, start_date, end_date)
    condition = Issue.where(user_id: user.id).where(happened_at: start_date..end_date)
    spend_hour_hash = condition.group(:happened_at).sum(:spend_hour)
    spend_minute_hash = condition.group(:happened_at).sum(:spend_minutes)

    @report_by_date = []
    (start_date..end_date).each do |date|
      hours = (spend_hour_hash[date].to_f + spend_minute_hash[date].to_f / 60).round(2)
      @report_by_date << [date, hours]
    end
  end

  def get_spend_hour_by_project(user, start_date, end_date)
    condition = Issue.where(user_id: user.id).where(happened_at: start_date..end_date)
    spend_hour_hash = condition.group(:project_id).sum(:spend_hour)
    spend_minute_hash = condition.group(:project_id).sum(:spend_minutes)

    @report_by_project = []
    condition.select(:project_id).distinct.map(&:project_id).each do |project_id|
      project = current_user.projects.find_by(id: project_id)
      if project.present?
        hours = (spend_hour_hash[project_id].to_f + spend_minute_hash[project_id].to_f / 60).round(2)
        @report_by_project << [project.name, hours]
      end
    end
  end
end
