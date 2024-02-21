class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :phone, presence: true
  validates :role, presence:true, inclusion: { in: ['customer', 'admin'],
  message: "User's role should be either 'customer' or 'admin'." }

  has_many :addresses, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :orders
  belongs_to :default_address, class_name: 'Address', foreign_key: 'default_address_id', optional: true

  after_create :create_cart_for_user
  before_validation :assign_role, on: :create

  def admin?
    self.role == 'admin'
  end

  def customer?
    self.role == 'customer'
  end

  private
  def create_cart_for_user
    if(self.customer?)
      Cart.create(user: self)
    end
  end

  def assign_role ## Change later to User controller
    self.role = 'customer'
  end
end
