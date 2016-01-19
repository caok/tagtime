# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :issues
  has_many :participations
  has_many :projects, through: :participations

  def more_dates_for_issues(start)
    issues.where("happened_at < ?", 6.days.ago).order(happened_at: :desc).select(:happened_at).distinct.offset(start).limit(7).map(&:happened_at)
  end

  def ensure_token
    self.token = generate_token if token.blank?
  end
  before_save :ensure_token

  def generate_name
    self.name = email.match(/^(\w+)@/)[1] if name.blank?
  end
  before_save :generate_name

  private
  def generate_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(token: token).first
    end
  end
end
