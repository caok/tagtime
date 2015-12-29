# == Schema Information
#
# Table name: participations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Participation < ActiveRecord::Base
  ROLE = ['owner', 'participator', 'manager']

  belongs_to :user
  belongs_to :project
  validates :role, :user_id, :project_id, presence: true
  validates_uniqueness_of :user_id, scope: :project_id

  def user_name
    user.try(:name)
  end

  def is_owner?
    role == 'owner'
  end

  def is_manager?
    ['owner', 'manager'].include? role
  end
end
