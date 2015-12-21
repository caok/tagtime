# == Schema Information
#
# Table name: issues
#
#  id            :integer          not null, primary key
#  number        :integer
#  spend_hour    :integer
#  spend_minutes :integer
#  repo_name     :string
#  repo_url      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
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
end
