class CreateApiRequests < ActiveRecord::Migration
  def change
    create_table :api_requests do |t|
      t.string :api_type
      t.text :api_request

      t.timestamps null: false
    end
  end
end
