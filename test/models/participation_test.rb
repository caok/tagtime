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

require 'test_helper'

class ParticipationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
