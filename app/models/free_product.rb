class FreeProduct < ApplicationRecord
  belongs_to :product, foreign_key: 'product_id', class_name: 'Product'
  belongs_to :free, foreign_key: 'free_id', class_name: 'Product'
end
