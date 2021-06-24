# == Schema Information
#
# Table name: stores
#
#  id             :bigint           not null, primary key
#  city           :string
#  num_coupons    :integer
#  state          :string
#  street_address :string
#  zip            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  grocer_id      :bigint
#
# Indexes
#
#  index_stores_on_grocer_id  (grocer_id)
#
# Foreign Keys
#
#  fk_rails_...  (grocer_id => grocers.id)
#
require "test_helper"

class StoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
