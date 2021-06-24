json.array! @stores do |store|
  json.partial! 'api/stores/store', store: store
end