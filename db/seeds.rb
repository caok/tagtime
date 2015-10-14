# issues

Issue.delete_all

(1..100).each do |no|
  Issue.create(number: no, spend_hour: (1..3).to_a.sample, spend_minutes: (1..60).to_a.sample, repo_name: "tagtime", repo_url: "https://github.com/xiongbo/tagtime")
end
