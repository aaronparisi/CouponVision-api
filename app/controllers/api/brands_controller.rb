class Api::BrandsController < ApplicationController
  def savings_by_brand
    @brands = Brand.savings_by_brand
    render json: @brands
  end
end
