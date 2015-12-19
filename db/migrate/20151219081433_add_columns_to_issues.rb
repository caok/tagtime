class AddColumnsToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :content, :text
    add_column :issues, :project_id, :integer
    add_column :issues, :user_id, :integer
    remove_column :issues, :repo_name
    remove_column :issues, :repo_url
  end
end
