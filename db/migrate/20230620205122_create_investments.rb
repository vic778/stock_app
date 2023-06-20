class CreateInvestments < ActiveRecord::Migration[7.0]
  def change
    create_table :investments do |t|
      t.string :symbol_of_stock
      t.float :purchase_price
      t.integer :number_of_shares
      t.date :purchase_date
      t.references :portfolio, null: false, foreign_key: true

      t.timestamps
    end
  end
end
