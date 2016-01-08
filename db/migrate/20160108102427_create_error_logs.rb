class CreateErrorLogs < ActiveRecord::Migration
  def change
    create_table :error_logs do |t|
      t.string :error_type
      t.text :message

      t.timestamps null: false
    end
  end
end
