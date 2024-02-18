class Product < ApplicationRecord
  belongs_to :category, optional: true
  has_many :carts_products, dependent: :destroy
  has_many :orders_products, dependent: :nullify
  has_one_attached :image

  validates :name, presence:true, length: { maximum: 255 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, length: { maximum: 1000 }
  validates :quantity_available, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :validate_image_type, if: -> { image.attached? }

  private
  def validate_image_type
    allowed_types = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']

    unless image.content_type.in?(allowed_types)
      errors.add(:image, "must be a valid image type (JPEG, JPEG, PNG, GIF)")
    end
  end
end
