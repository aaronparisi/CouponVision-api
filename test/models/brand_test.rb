# == Schema Information
#
# Table name: brands
#
#  id                       :bigint           not null, primary key
#  earliest_activation_date :date
#  latest_activation_date   :date
#  max_activation_days      :integer
#  max_coupon_value         :decimal(, )
#  min_coupon_value         :decimal(, )
#  name                     :string
#  num_products             :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
require "test_helper"

class BrandTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
