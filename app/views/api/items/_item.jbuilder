json.title item.title
json.content item.content
json.value item.value
json.parent_id item.parent_id
json.id item.id
json.children do
  json.array! item.children do |child|
    json.partial! 'api/items/item', item: child
  end
end
