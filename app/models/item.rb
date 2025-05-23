class Item < ApplicationRecord
  belongs_to :restaurant


  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :category, presence: true
  validates :restaurant_id, presence: true
end
