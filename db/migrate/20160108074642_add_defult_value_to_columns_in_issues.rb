class AddDefultValueToColumnsInIssues < ActiveRecord::Migration
  def change
    change_column_default :issues, :number, 0
    change_column_default :issues, :spend_hour, 0
    change_column_default :issues, :spend_minutes, 0
  end
end
