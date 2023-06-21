class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :portfolios, dependent: :destroy
  validates :name, presence: true
  validates :password_confirmation, presence: true

  def requires_confirmation?
    !confirmed?
  end

  def generate_jwt
    JWT.encode({ id:, exp: 30.days.from_now.to_i }, 'vicSecret')
  end
end
