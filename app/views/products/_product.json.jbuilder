json.extract! product, :id, :user_id, :group_id, :title, :created_at, :updated_at
json.url product_url(product, format: :json)
