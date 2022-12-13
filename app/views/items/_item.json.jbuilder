json.extract! item, :id, :item_name, :item_qty, :item_des, :created_at, :updated_at
json.url item_url(item, format: :json)
