class Participation < ActiveRecord::Base
  ROLE = ['owner', 'participator', 'viewer']

  belongs_to :user
  belongs_to :project
  validates :role, :user_id, :project_id, presence: true
  validates_uniqueness_of :user_id, scope: :project_id
end
