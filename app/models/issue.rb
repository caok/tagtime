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
  default_scope { order(id: :desc) }

  def user_name
    user.try(:email)
  end

  def project_name
    project.try(:name)
  end

  def body
    "@#{project_name} ##{number}  #{content}  #{spend_hour}h#{spend_minutes}m"
  end

  def body_without_time
    "@#{project_name} ##{number}  #{content}"
  end

  def spend_time
    "#{spend_hour}h#{spend_minutes}m"
  end
end
