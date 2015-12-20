json.array!(@projects) do |project|
  json.extract! project, :id, :name, :content, :repo_url
  json.url project_url(project, format: :json)
end
