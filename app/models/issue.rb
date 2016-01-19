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

  scope :order_by_date_and_project, -> { order(happened_at: :desc, project_id: :desc).includes(:project) }
  scope :recent, -> { order_by_date_and_project.where(happened_at: (6.days.ago..Date.today)) }
  scope :more, -> (dates) { where(happened_at: dates).order_by_date_and_project }

  def user_name
    user.try(:name)
  end

  def project_name
    project.try(:name)
  end

  def body
    str = ""
    str += "@#{project_name} " if project_name.present?
    str += "##{number} " if number.to_i > 0
    str += "#{content}"
    str += " #{spend_hour}h" if spend_hour.to_i > 0
    str += "#{spend_minutes}m" if spend_minutes.to_i > 0

    str
  end

  def body_without_time
    str = ""
    str += "@#{project_name} " if project_name.present?
    str += "##{number} " if number.to_i > 0
    str += "#{content}"

    str
  end

  def body_without_time_and_project
    str = ""
    str += "##{number} " if number.to_i > 0
    str += "#{content}"

    str
  end

  def spend_time
    str = ''
    str += "#{spend_hour}h" if spend_hour.to_i > 0
    str += "#{spend_minutes}m" if spend_minutes.to_i > 0
    str = '0' if str.blank?

    str
  end

  def split_by_date
  end
end
