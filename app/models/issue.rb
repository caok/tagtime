# == Schema Information
#
# Table name: issues
#
#  id               :integer          not null, primary key
#  number           :integer
#  spend_hour       :integer
#  spend_minutes    :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  content          :text
#  project_id       :integer
#  user_id          :integer
#  happened_at      :date
#  original_content :text
#

class Issue < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  PAGE_COUNT = 10

  scope :recent, -> { order(id: :desc).where(happened_at: (Date.today.beginning_of_week..Date.today.end_of_week)) }

  scope :more, -> (page) {
    order(id: :desc).where(happened_at: (Date.today.end_of_week.weeks_ago(page)..Date.today.beginning_of_week))
  }

  def user_name
    user.try(:email)
  end

  def project_name
    project.try(:name)
  end

  def body
    str = ""
    str += "@#{project_name} " if project_name.present?
    str += "##{number} " if number.nonzero?
    str += "#{content}"
    str += " #{spend_hour}h" if spend_hour > 0
    str += "#{spend_minutes}m" if spend_minutes > 0

    str
  end

  def body_without_time
    str = ""
    str += "@#{project_name} " if project_name.present?
    str += "##{number}  " if number.nonzero?
    str += "#{content}"

    str
  end

  def spend_time
    str = ''
    str += "#{spend_hour}h " if spend_hour > 0
    str += "#{spend_minutes}m" if spend_minutes > 0
    str = '0' if str.blank?

    str
  end

  def split_by_date
  end
end
