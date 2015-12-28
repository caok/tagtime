json.type "success"
json.message "destroy issue tag!"
json.list do
  json.partial! 'issues/issue', collection: @issues, as: :issue 
end
