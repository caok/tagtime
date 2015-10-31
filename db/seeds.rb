# issues 
Issue.delete_all

(1..1000).each do |no|
  Issue.create(number: no, spend_hour: (1..3).to_a.sample, spend_minutes: (1..60).to_a.sample, repo_name: "feedmob", repo_url: "https://github.com/brtr/feedmob/issues")
end
