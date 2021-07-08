class Api::GrocersController < ApplicationController
  # stacked bar
  def coupon_counts_by_brand
    @grocers = Grocer.coupon_counts_by_brand  ## formatted grocer data
    @brands = Brand.all  ## for color coding brand legend
  end

  # line
  def active_coupons_over_time
    @grocers = Grocer.active_over_time
  end
end
