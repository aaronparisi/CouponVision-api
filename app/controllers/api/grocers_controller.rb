class Api::GrocersController < ApplicationController
  def coupon_counts_by_brand
    @grocers = Grocer.coupon_counts_by_brand
    @brands = Brand.all
  end

  def coupons_by_brand
    @grocers = Grocer.all
    @brands = Brand.all
  end
end
