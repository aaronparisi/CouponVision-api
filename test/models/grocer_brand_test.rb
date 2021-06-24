# == Schema Information
#
# Table name: grocer_brands
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  brand_id   :bigint           not null
#  grocer_id  :bigint           not null
#
# Indexes
#
#  index_grocer_brands_on_brand_id   (brand_id)
#  index_grocer_brands_on_grocer_id  (grocer_id)
#
# Foreign Keys
#
#  fk_rails_...  (brand_id => brands.id)
#  fk_rails_...  (grocer_id => grocers.id)
#
require "test_helper"

class GrocerBrandTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
