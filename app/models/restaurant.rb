class Restaurant < ApplicationRecord
  has_many :items
  belongs_to :user
  
  validates :name, presence: true

  
end
