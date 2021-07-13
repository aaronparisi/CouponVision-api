require 'roo'

dataPath = File.join(Rails.root, 'lib', 'Grocery_UPC_Database.xlsx')
data = Roo::Spreadsheet.open(dataPath)

num_brands_from_excel = 10  ## limit number of brands in sample
max_num_brands_per_grocer = 10  ## grocers' coupons can come from some subset of brands
max_num_products_per_brand = 10

max_num_stores_per_grocer = 30
max_num_coupons_per_store = 50

days_from_now = 1000

def fakerRand(min, max)
  ## returns a random number between min and max using Faker gem
  return Faker::Number.between(from: min, to: max)
end

# brands
puts "making brands"
brand_indices = (1..data.sheet('brands').last_row).to_a.shuffle[0...num_brands_from_excel]
brand_indices.each do |brand_idx|
  brand = data.sheet('brands').row(brand_idx)
  min_val = fakerRand(0.1, 50.0)
  max_val = fakerRand(min_val, 50.0)

  Brand.create(
    name: brand[0], 
    min_coupon_value: min_val,
    max_coupon_value: max_val,
    num_products: fakerRand(1, max_num_products_per_brand)
  )
end

# products from included brands only
puts "making products"
Brand.all.each do |brand|
  puts "making #{brand.num_products} products for brand #{brand.name}"
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
  early_act = Faker::Date.between(from: days_from_now.days.ago, to: days_from_now.days.from_now)
  late_act = Faker::Date.between(from: early_act, to: days_from_now.days.from_now)

  max_activation_days = Faker::Number.between(from: 7, to: 500)

  Grocer.create(
    name: grocer[1].value,
    num_brands: fakerRand(1,max_num_brands_per_grocer),
    num_stores: fakerRand(1,max_num_stores_per_grocer),
    max_num_coupons_per_store: fakerRand(0, max_num_coupons_per_store),
    earliest_activation_date: early_act,
    latest_activation_date: late_act,
    max_activation_days: max_activation_days,
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
      num_coupons: fakerRand(0, grocer.max_num_coupons_per_store)
    ).save
  end
end

puts "making coupons"
Store.all.each do |store|
  store.num_coupons.times do
    aBrand = store.grocer.brands.sample(1)[0]
    aProduct = aBrand.products.sample(1)[0]
    act_date = Faker::Date.between(from: store.grocer.earliest_activation_date, to: store.grocer.latest_activation_date)
    exp_date = Faker::Date.between(from: act_date, to: act_date + store.grocer.max_activation_days.days)
  
    store.coupons.build(
      cash_value: fakerRand(aBrand.min_coupon_value, aBrand.max_coupon_value),
      savings: fakerRand(aBrand.min_coupon_value, aBrand.max_coupon_value),
      activation_date: act_date,
      expiration_date: exp_date,
      product_id: aProduct.id
    ).save
  end
end