# == Schema Information
#
# Table name: grocers
#
#  id         :bigint           not null, primary key
#  name       :string
#  num_brands :integer
#  num_stores :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Grocer < ApplicationRecord
  has_many :stores

  has_many :grocer_brands
  has_many :brands, through: :grocer_brands, source: :brand
end
