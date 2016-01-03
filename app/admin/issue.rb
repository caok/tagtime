ActiveAdmin.register Issue do
  menu :priority => 4

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
