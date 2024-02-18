class Address < ApplicationRecord
  belongs_to :user
  has_many :orders

  validates :user, presence: true
  validates :street, presence: true, length: { maximum: 255 }
  validates :city, presence: true, length: { maximum: 255 }
  validates :state, presence: true, length: { maximum: 255 }
  validates :zip_code, presence: true, length: { maximum: 20 }
  validates :country, presence: true, length: { maximum: 255 }
end
