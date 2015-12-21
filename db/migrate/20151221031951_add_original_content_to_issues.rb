class AddOriginalContentToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :original_content, :text
  end
end
