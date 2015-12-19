class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :content
      t.string :repo_url

      t.timestamps null: false
    end
  end
end
