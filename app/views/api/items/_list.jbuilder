json.array! items do |item|
  json.partial! 'api/items/item', item: item
end
