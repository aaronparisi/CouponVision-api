json.grocers do
  # json.array! @grocers do |grocer|
  #   # json.partial! 'api/grocers/grocer', grocer: grocer
  #   # json.extract! grocer, :counts
  #   json.grocer!
  # end
  json.array! @grocers
end

json.brands do
  json.array! @brands do |brand|
    json.partial! 'api/brands/brand', brand: brand
  end
end