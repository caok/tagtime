ActiveAdmin.register Issue do
  menu :priority => 4
  permit_params :number, :spend_hour, :spend_minutes, :content, :project_id, :user_id, :happened_at, :original_content

  index do
    selectable_column
    id_column
    column :project
    column :user
    column :number
    column :content
    column :spend do |issue|
      issue.spend_time
    end
    column :happened_at
    column :created_at
    actions
  end

  filter :project
  filter :user
  filter :number
  filter :content
  filter :happened_at
end
