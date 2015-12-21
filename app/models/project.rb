class Project < ActiveRecord::Base
  include AASM

  has_many :issues
  has_many :participations
  has_many :users, through: :participations

  validates :name, presence: true
  validates :repo_url, presence: true, uniqueness: true

  aasm :column => :state do
    state :running, :initial => true
    state :closed

    event :close do
      transitions :from => :running, :to => :closed
    end
  end

  before_validation :downcase_name
  def downcase_name
    self.name = name.downcase
  end
end
