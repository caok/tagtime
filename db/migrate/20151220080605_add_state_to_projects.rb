class AddStateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :state, :string, default: 'running'
  end
end
