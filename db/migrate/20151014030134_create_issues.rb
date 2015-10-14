class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t| 
      t.integer :number
      t.integer :spend_hour
      t.integer :spend_minutes
      t.string :repo_name
      t.string :repo_url

      t.timestamps null: false
    end
  end
end
