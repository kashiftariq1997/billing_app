# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :free_products, dependent: :destroy
  has_many :prime_products, through: :free_products, class_name: 'Product'

  validates_uniqueness_of :code
  validates :code, format: { with: /\A[A-Z]+\z/, message: 'only allows capital letters' }
  validates :price, :volume, :volume_price, numericality: true
end
