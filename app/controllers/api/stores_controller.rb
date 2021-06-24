class Api::StoresController < ApplicationController
  def total_savings
    @stores = Store.includes(:grocer, :coupons)
  end
end
