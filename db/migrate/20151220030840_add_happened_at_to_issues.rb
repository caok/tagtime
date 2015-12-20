class AddHappenedAtToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :happened_at, :date
  end
end
