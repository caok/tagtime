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
end
