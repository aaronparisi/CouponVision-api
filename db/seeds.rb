# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'roo'

# data = Roo::Spreadsheet.open('./lib/Grocery_UPC_Data.xlsx')
dataPath = File.join(Rails.root, 'lib', 'Grocery_UPC_Database.xlsx')
data = Roo::Spreadsheet.open(dataPath)

num_brands = 10
max_num_products = 5

max_num_stores = 5
max_num_coupons = 5

def fakerRand(min, max)
  return Faker::Number.between(from: min, to: max)
end

# brands
puts "making brands"
brand_indices = (1..data.sheet('brands').last_row).to_a.shuffle[0...num_brands]
brand_indices.each do |brand_idx|
  brand = data.sheet('brands').row(brand_idx)
  min_val = fakerRand(0.1, 50.0)
  max_val = fakerRand(min_val, 50.0)
  early_exp = Faker::Date.between(from: 500.days.ago, to: 500.days.from_now)
  late_exp = Faker::Date.between(from: early_exp, to: 500.days.from_now)

  Brand.create(
    name: brand[0], 
    min_coupon_value: min_val,
    max_coupon_value: max_val,
    earliest_expiration_date: early_exp,
    latest_expiration_date: late_exp,
    num_products: max_num_products
  )
end

# products from included brands only
puts "making products"
Brand.all.each do |brand|
  product_indices = (1..data.sheet('products').last_row)
    .to_a
    .filter { |idx| brand.name === data.sheet('products').row(idx)[1] }
    .shuffle[0...brand.num_products]

  product_indices.each do |product_idx|
    product_row = data.sheet('products').row(product_idx)
    brand.products.build(name: product_row[3]).save
  end
end

# gorcers
puts "making grocers"
data.sheet('grocers').each_row_streaming(offset: 1) do |grocer|
  Grocer.create(
    name: grocer[1].value,
    num_brands: fakerRand(1,num_brands),
    num_stores: fakerRand(1,max_num_stores)
  )
end

# adding brands to grocers
puts "making grocer_brands"
Grocer.all.each do |grocer|
  Brand.pluck(:id).sample(grocer.num_brands).each do |brand_id|
    grocer.grocer_brands.build(brand_id: brand_id).save
  end
end

puts "making stores"
Grocer.all.each do |grocer|
  grocer.num_stores.times do
    grocer.stores.build(
      street_address: Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      zip: Faker::Address.zip_code,
      num_coupons: fakerRand(0, max_num_coupons)
    ).save
  end
end

puts "making coupons"
Store.all.each do |store|
  store.num_coupons.times do
    aBrand = store.grocer.brands.sample(1)[0]
    aProduct = aBrand.products.sample(1)[0]
    exp_date = Faker::Date.between(from: aBrand.earliest_expiration_date, to: aBrand.latest_expiration_date),

    store.coupons.build(
      cash_value: fakerRand(aBrand.min_coupon_value, aBrand.max_coupon_value),
      savings: fakerRand(aBrand.min_coupon_value, aBrand.max_coupon_value),
      expiration_date: exp_date,
      product_id: aProduct.id
    ).save
  end
end