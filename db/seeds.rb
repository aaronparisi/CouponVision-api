# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'roo'

data = Roo::Spreadsheet.open('../lib/Grocery_UPC_Data.xlsx')

# brands
data.sheet('brands').each(name: 'name') do |brand|
  Brand.create(name: brand.name)
end

# products
data.sheet('products').each(brand_id: 'brand_id', name: 'name') do |product|
  Brand.find(product.brand_id).products.build(name: product.name)
end

# 5 coupons per product
Product.all.each do |product|
  5.times do
    product.coupons.build(
      savings: Faker::Number.between(from: 0.1, to: 5.0),
      cash_value: Faker::Number.between(from: 0.1, to: 5.0),
      expiration_date: Faker::Date.between(from: 500.days.ago, to: 500.days.from_now)
    )
  end
end

# gorcers
data.sheet('grocers').each(name: 'name') do |grocer|
  Grocer.create(name: grocer.name)
end

# 5 stores per grocer
Grocer.all.each do |grocer|
  5.times do
    grocer.stores.build(
      street_address: Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state,
      zip: Faker::Address.zip_code
    )
  end
end

# each coupon will be valid in 5 stores
Coupon.all.each do |coupon|
  5.times do
    aStore = Store.find(Store.pluck(:id).sample)
    # * ensure no duplicate coupon-store pairs
    while (aStore.coupons.exists?(coupon.id))
      aStore = Store.find(Store.pluck(:id).sample)
    end

    CouponStore.create(coupon_id: coupon.id, store_id: aStore.id)
  end
end