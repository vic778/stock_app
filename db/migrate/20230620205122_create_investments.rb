class CreateInvestments < ActiveRecord::Migration[7.0]
  def change
    create_table :investments do |t|
      t.string :symbol
      t.float :purchase_price, default: 0.0
      t.float :current_value, default: 0.0
      t.float :daily_gain_loss, default: 0.0
      t.integer :number_of_shares, default: 0
      t.datetime :purchase_date
      t.boolean :has_gain, default: false
      t.references :portfolio, null: false, foreign_key: true

      t.timestamps
    end
  end
end
