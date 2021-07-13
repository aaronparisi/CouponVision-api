class Api::BrandsController < ApplicationController
  ## atodo I'm not sure if breaking down the coupons by state
  ## is the most interesting visualization,
  ## maybe by grocer is better?
  def savings_by_brand
    @brands = Brand.savings_by_brand
    render json: @brands
  end
end
