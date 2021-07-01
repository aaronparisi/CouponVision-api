# == Schema Information
#
# Table name: grocers
#
#  id              :bigint           not null, primary key
#  max_num_coupons :integer
#  name            :string
#  num_brands      :integer
#  num_stores      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
