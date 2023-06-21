class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :investments, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
