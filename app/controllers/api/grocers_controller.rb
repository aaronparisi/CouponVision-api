class Api::GrocersController < ApplicationController
  # stacked bar
  def coupon_counts_by_brand
    @grocers = Grocer.coupon_counts_by_brand
    @brands = Brand.all
  end

  # line
  def active_coupons_over_time
    @grocers = Grocer.all
    @brands = Brand.all
  end
end
