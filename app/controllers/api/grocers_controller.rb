class Api::GrocersController < ApplicationController
  def coupon_counts_by_brand
    @grocers = Grocer.coupon_counts_by_brand  ## formatted grocer data
    @brands = Brand.all  ## for color coding brand legend
    ## I want a single source of brand data separate from
    ## the grocers data,
    ## since any particular grocer may or may not have any coupons
    ## for any particular brand
  end

  def active_coupons_over_time
    @grocers = Grocer.active_over_time
  end
end

## anote
## currently these render a jbuilder partial,
## that may not be necessary anymore but I just left it as is for now