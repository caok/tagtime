module Apis
  class GithubController < ApplicationController
    abstract!
    skip_before_action :verify_authenticity_token 

    def push 
      commit = params[:head_commit]
      user = get_user(commit)
      message = match_message(commit)
      repo = get_repo
      happened_at = get_date(commit)
      Issue.create(
        project_id: repo, user: user, happened_at: happened_at,
        number: message[0], spend_hour: message[1], 
        spend_minutes: message[2], content: message[3]
      )
      render text: "successful"
    end

    private
    def get_user(commit) 
      User.find_by(email: commit[:author][:email])
    end 

    def get_repo
      repo = params[:repository]
      repo_id = Project.find_by(name: repo[:name]).try(:id) 
    end

    def get_date(commit)
      timestamp = commit[:timestamp]
      timestamp.to_date
    end

    def match_message(commit)
      message = commit[:message].strip
      return nil if message.blank?  
      content = message

      number = message.match(/\#\d+[ ;,.，。]?/).to_s.strip
      hours = message.match(/[\d.]+(hrs|hr|h|H)+/).to_s.strip
      minutes = message.match(/[\d.]+(mins|min|m|M)+/).to_s.strip 

      [number, hours, minutes].each {|s| content = content.gsub(/#{s}/, '')}
      
      content = content.strip

      number = number.gsub(/[# ;,，。]/, '')
      hours = hours.gsub(/(hrs|hr|h|H)/, '').to_f
      minutes = minutes.gsub(/(mins|min|m|M)/, '').to_i 

      if hours != hours.to_i
        minutes = (minutes + (hours - hours.to_i)*60).to_i
        hours = hours.to_i + (minutes/60).to_i
        minutes = (minutes%60).to_i
      end 

      message = [number, hours.to_i, minutes, content]
    end 
  end
end
