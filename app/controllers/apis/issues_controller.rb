module Apis
  class IssuesController < BaseController 
    before_action :break_tag, only: [:create]

    def index 
      @issues = @user.issues#.last(10)
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

    private
    attr_reader :tags
    def generate_params 
      ActionController::Parameters.new(project_id: tags[0],
                                       number: tags[1],
                                       spend_hour: tags[2],
                                       spend_minutes: tags[3],
                                       happened_at: tags[4],
                                       content: tags[5],
                                       original_content: tags[6]).permit!
    end

    def break_tag
      tag = params[:tag].try(:strip)
      return nil if tag.blank?
      project = tag.match(/\@\w+[ ;,.，。]?/).to_s
      number = tag.match(/\#\d+[ ;,.，。]?/).to_s
      hours = tag.match(/[\d.]+(hrs|hr|h|H)+/).to_s
      minutes = tag.match(/[\d.]+(mins|min|m|M)+/).to_s

      content = original_content = tag
      [project,number,hours,minutes].each {|s| content = content.gsub(/#{s}/, '')}
      content = content.try(:strip)

      number = number.gsub(/[# ;,，。]/, '')
      hours = hours.gsub(/(hrs|hr|h|H)/, '').to_f
      minutes = minutes.gsub(/(mins|min|m|M)/, '').to_i

      project = project.gsub(/[@ ;,，。]/, '').try(:downcase)
      project_id = Project.find_by(name: project).try(:id)

      if hours != hours.to_i
        minutes = (minutes + (hours - hours.to_i)*60).to_i
        hours = hours.to_i
      end

      happened_at = Date.today

      @tags = [project_id, number, hours.to_i, minutes, happened_at, content, original_content]
    end
  end
end
