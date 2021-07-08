# == Schema Information
#
# Table name: grocers
#
#  id                        :bigint           not null, primary key
#  earliest_activation_date  :date
#  latest_activation_date    :date
#  max_activation_days       :integer
#  max_num_coupons_per_store :integer
#  name                      :string
#  num_brands                :integer
#  num_stores                :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
