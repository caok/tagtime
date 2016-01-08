module Apis
  class GithubController < ApplicationController
    abstract!
    skip_before_action :verify_authenticity_token 
    before_action :convert_response, only: [:push]

    def push 
      commit = @response[:head_commit]
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
      ApiRequest.create(api_type: "github", api_request: request.body.read)
      @response = JSON.parse("#{request.body.read}")
      # @response = JSON.parse '{"ref":"refs/heads/master","before":"488cb0af7b3dc8df57f94bd3b600f2bcf663b3d4","after":"d5a06434f98df79423beb7c01e34b7657c72466b","created":false,"deleted":false,"forced":false,"base_ref":null,"compare":"https://github.com/Techbay/tagtime/compare/488cb0af7b3d...d5a06434f98d","commits":[{"id":"d5a06434f98df79423beb7c01e34b7657c72466b","distinct":false,"message":"Refs #33 10m","timestamp":"2016-01-08T21:00:56+08:00","url":"https://github.com/Techbay/tagtime/commit/d5a06434f98df79423beb7c01e34b7657c72466b","author":{"name":"xiongbo","email":"xiongbo027@gmail.com","username":"xiongbo"},"committer":{"name":"xiongbo","email":"xiongbo027@gmail.com","username":"xiongbo"},"added":[],"removed":[],"modified":["app/controllers/apis/github_controller.rb"]}],"head_commit":{"id":"d5a06434f98df79423beb7c01e34b7657c72466b","distinct":false,"message":"Refs #33 10m","timestamp":"2016-01-08T21:00:56+08:00","url":"https://github.com/Techbay/tagtime/commit/d5a06434f98df79423beb7c01e34b7657c72466b","author":{"name":"xiongbo","email":"xiongbo027@gmail.com","username":"xiongbo"},"committer":{"name":"xiongbo","email":"xiongbo027@gmail.com","username":"xiongbo"},"added":[],"removed":[],"modified":["app/controllers/apis/github_controller.rb"]},"repository":{"id":48217166,"name":"tagtime","full_name":"Techbay/tagtime","owner":{"name":"Techbay","email":"support@techbay.club"},"private":true,"html_url":"https://github.com/Techbay/tagtime","description":"a tool to tag time when you working on your project","fork":true,"url":"https://github.com/Techbay/tagtime","forks_url":"https://api.github.com/repos/Techbay/tagtime/forks","keys_url":"https://api.github.com/repos/Techbay/tagtime/keys{/key_id}","collaborators_url":"https://api.github.com/repos/Techbay/tagtime/collaborators{/collaborator}","teams_url":"https://api.github.com/repos/Techbay/tagtime/teams","hooks_url":"https://api.github.com/repos/Techbay/tagtime/hooks","issue_events_url":"https://api.github.com/repos/Techbay/tagtime/issues/events{/number}","events_url":"https://api.github.com/repos/Techbay/tagtime/events","assignees_url":"https://api.github.com/repos/Techbay/tagtime/assignees{/user}","branches_url":"https://api.github.com/repos/Techbay/tagtime/branches{/branch}","tags_url":"https://api.github.com/repos/Techbay/tagtime/tags","blobs_url":"https://api.github.com/repos/Techbay/tagtime/git/blobs{/sha}","git_tags_url":"https://api.github.com/repos/Techbay/tagtime/git/tags{/sha}","git_refs_url":"https://api.github.com/repos/Techbay/tagtime/git/refs{/sha}","trees_url":"https://api.github.com/repos/Techbay/tagtime/git/trees{/sha}","statuses_url":"https://api.github.com/repos/Techbay/tagtime/statuses/{sha}","languages_url":"https://api.github.com/repos/Techbay/tagtime/languages","stargazers_url":"https://api.github.com/repos/Techbay/tagtime/stargazers","contributors_url":"https://api.github.com/repos/Techbay/tagtime/contributors","subscribers_url":"https://api.github.com/repos/Techbay/tagtime/subscribers","subscription_url":"https://api.github.com/repos/Techbay/tagtime/subscription","commits_url":"https://api.github.com/repos/Techbay/tagtime/commits{/sha}","git_commits_url":"https://api.github.com/repos/Techbay/tagtime/git/commits{/sha}","comments_url":"https://api.github.com/repos/Techbay/tagtime/comments{/number}","issue_comment_url":"https://api.github.com/repos/Techbay/tagtime/issues/comments{/number}","contents_url":"https://api.github.com/repos/Techbay/tagtime/contents/{+path}","compare_url":"https://api.github.com/repos/Techbay/tagtime/compare/{base}...{head}","merges_url":"https://api.github.com/repos/Techbay/tagtime/merges","archive_url":"https://api.github.com/repos/Techbay/tagtime/{archive_format}{/ref}","downloads_url":"https://api.github.com/repos/Techbay/tagtime/downloads","issues_url":"https://api.github.com/repos/Techbay/tagtime/issues{/number}","pulls_url":"https://api.github.com/repos/Techbay/tagtime/pulls{/number}","milestones_url":"https://api.github.com/repos/Techbay/tagtime/milestones{/number}","notifications_url":"https://api.github.com/repos/Techbay/tagtime/notifications{?since,all,participating}","labels_url":"https://api.github.com/repos/Techbay/tagtime/labels{/name}","releases_url":"https://api.github.com/repos/Techbay/tagtime/releases{/id}","created_at":1450418005,"updated_at":"2015-12-19T01:30:40Z","pushed_at":1452258233,"git_url":"git://github.com/Techbay/tagtime.git","ssh_url":"git@github.com:Techbay/tagtime.git","clone_url":"https://github.com/Techbay/tagtime.git","svn_url":"https://github.com/Techbay/tagtime","homepage":"","size":1888,"stargazers_count":0,"watchers_count":0,"language":"JavaScript","has_issues":true,"has_downloads":true,"has_wiki":true,"has_pages":false,"forks_count":0,"mirror_url":null,"open_issues_count":10,"forks":0,"open_issues":10,"watchers":0,"default_branch":"master","stargazers":0,"master_branch":"master","organization":"Techbay"},"pusher":{"name":"xiongbo","email":"xiongbo027@gmail.com"},"organization":{"login":"Techbay","id":8760880,"url":"https://api.github.com/orgs/Techbay","repos_url":"https://api.github.com/orgs/Techbay/repos","events_url":"https://api.github.com/orgs/Techbay/events","members_url":"https://api.github.com/orgs/Techbay/members{/member}","public_members_url":"https://api.github.com/orgs/Techbay/public_members{/member}","avatar_url":"https://avatars.githubusercontent.com/u/8760880?v=3","description":""},"sender":{"login":"xiongbo","id":1317465,"avatar_url":"https://avatars.githubusercontent.com/u/1317465?v=3","gravatar_id":"","url":"https://api.github.com/users/xiongbo","html_url":"https://github.com/xiongbo","followers_url":"https://api.github.com/users/xiongbo/followers","following_url":"https://api.github.com/users/xiongbo/following{/other_user}","gists_url":"https://api.github.com/users/xiongbo/gists{/gist_id}","starred_url":"https://api.github.com/users/xiongbo/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/xiongbo/subscriptions","organizations_url":"https://api.github.com/users/xiongbo/orgs","repos_url":"https://api.github.com/users/xiongbo/repos","events_url":"https://api.github.com/users/xiongbo/events{/privacy}","received_events_url":"https://api.github.com/users/xiongbo/received_events","type":"User","site_admin":false}}'
      # @response.deep_symbolize_keys!
    rescue => e
      ErrorLog.create(error_type: "github request", message: e.message)
    end
  end
end
