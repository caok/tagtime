ActiveAdmin.register Participation do
  menu :priority => 3
  permit_params :user_id, :project_id, :role

  index do
    selectable_column
    id_column
    column :user
    column :project
    column :role
    column :created_at
    actions
  end

  filter :user
  filter :project
  filter :created_at

  form do |f|
    f.inputs "User Details" do
      f.input :user
      f.input :project
      f.input :role, as: :select, collection: Participation::ROLE
    end
    f.actions
  end
end
