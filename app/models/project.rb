# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string
#  content    :text
#  repo_url   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state      :string           default("running")
#

class Project < ActiveRecord::Base
  include AASM

  has_many :issues
  has_many :participations
  has_many :users, through: :participations
  scope :active, -> { where(state: 'running') }

  validates :name, presence: true
  validates :repo_url, presence: true, uniqueness: true

  aasm :column => :state do
    state :running, :initial => true
    state :closed

    event :close do
      transitions :from => :running, :to => :closed
    end
  end

  def spend_hours
    (issues.sum(:spend_hour) + (issues.sum(:spend_minutes) || 0)/60.0).round(2)
  end

  def members
    if users.count > 3
      users.first(3).map(&:name).join(', ') + "  +#{users.count - 3}"
    else
      users.map(&:name).join(', ')
    end
  end

  before_validation :downcase_name
  def downcase_name
    self.name = name.downcase
  end
end
