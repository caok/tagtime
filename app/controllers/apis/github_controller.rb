module Apis
  class GithubController < ApplicationController
    abstract!
    skip_before_action :verify_authenticity_token 
    before_action :convert_response, only: [:push]

    def push 
      @response[:commits].each do |commit| 
        user = get_user(commit)
        message = match_message(commit)
        repo = get_repo(commit)
        happened_at = get_date(commit)
        Issue.create(
          project_id: repo, user: user, happened_at: happened_at,
          number: message[0], spend_hour: message[1], 
          spend_minutes: message[2], content: message[3]
        )
      end
      render text: "successful"
    end

    private
    def get_user(commit) 
      User.find_by(email: commit[:author][:email])
    end 

    def get_repo(commit)
      repo = @response[:repository]
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

    def convert_response
      ApiRequest.create(api_type: "github", api_request: request.body)
      @response = JSON.parse(request.body)
      # @response = {
      #   "commits": [{
      #     "id": "0d1a26e67d8f5eaf1f6ba5c57fc3c7d91ac0fd1c",
      #     "distinct": true,
      #     "message": "Update README.md",
      #     "timestamp": "2015-05-05T19:40:15-04:00",
      #     "url": "https://github.com/baxterthehacker/public-repo/commit/0d1a26e67d8f5eaf1f6ba5c57fc3c7d91ac0fd1c",
      #     "author": {
      #       "name": "baxterthehacker",
      #       "email": "xiongbo027@gmail.com",
      #       "username": "baxterthehacker"
      #     },
      #     "committer": {
      #       "name": "baxterthehacker",
      #       "email": "baxterthehacker@users.noreply.github.com",
      #       "username": "baxterthehacker"
      #     },
      #     "added": [

      #     ],
      #     "removed": [

      #     ],
      #     "modified": [
      #       "README.md"
      #     ]
      #   }],
      #   "repository": {
      #     "id": 35129377,
      #     "name": "feedmob",
      #     "full_name": "baxterthehacker/public-repo",
      #     "owner": {
      #       "name": "baxterthehacker",
      #       "email": "baxterthehacker@users.noreply.github.com"
      #     }
      #   }
      # }
    rescue => e
      ErrorLog.create("github request", e.message)
    end
  end
end
