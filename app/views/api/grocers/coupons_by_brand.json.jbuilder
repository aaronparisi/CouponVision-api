json.grocers do
  json.array! @grocers do |grocer|
    # json.partial! 'api/grocers/grocer', grocer: grocer
    json.extract! grocer, :id, :name, :coupons_by_brand
  end
end

json.brands do
  json.array! @brands do |brand|
    json.partial! 'api/brands/brand', brand: brand
  end
end