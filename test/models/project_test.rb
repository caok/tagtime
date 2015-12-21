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

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
