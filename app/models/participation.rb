class Participation < ActiveRecord::Base
  ROLE = ['owner', 'participator', 'viewer']

  belongs_to :user
  belongs_to :project
end
