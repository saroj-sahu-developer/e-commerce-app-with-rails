class Product < ApplicationRecord
  belongs_to :category, optional: true
  has_many :carts_products, dependent: :destroy
  has_many :orders_products, dependent: :nullify
  # has_one_attached :image
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :medium, resize_to_limit: [300, 300]
    attachable.variant :large, resize_to_limit: [600, 600]
  end

  validates :name, presence:true, length: { maximum: 255 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, length: { maximum: 1000 }
  validates :quantity_available, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :validate_image_type, if: -> { images.attached? }

  private
  def validate_image_type
    allowed_types = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']
    
    images.each do |image|
      unless image.content_type.in?(allowed_types)
        errors.add(:images, "must be a valid image type (JPEG, JPEG, PNG, GIF)")
      end
    end
  end
end
