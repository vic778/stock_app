class Investment < ApplicationRecord
  belongs_to :portfolio

  validates :symbol_of_stock, presence: true
  validates :number_of_shares, presence: true
  validates :purchase_price, presence: true
  validates :purchase_date, presence: true
end
