class Category < ApplicationRecord
  has_many :products, dependent: :nullify

  validates :name, presence:true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }
end
