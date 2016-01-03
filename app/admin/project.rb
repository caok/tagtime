ActiveAdmin.register Project do
  menu :priority => 2
  permit_params :name, :content, :repo_url, :state

  index do
    selectable_column
    id_column
    column :name
    column :state
    column :repo_url
    column :members do |project|
      project.users.count
    end
    column :issues do |project|
      project.issues.count
    end
    column :created_at
    actions
  end

  filter :name
  filter :state
  filter :created_at

  form do |f|
    f.inputs "Project Details" do
      f.input :name
      f.input :state, as: :select, collection:  Project.aasm.states_for_select
      f.input :repo_url
      f.input :content
    end
    f.actions
  end
end
