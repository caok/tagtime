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

require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
