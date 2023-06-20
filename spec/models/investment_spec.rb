require 'rails_helper'

RSpec.describe Investment, type: :model do
  describe 'associations' do
    it { should belong_to(:portfolio) }
  end

  describe 'validations' do
    it { should validate_presence_of(:symbol_of_stock) }
    it { should validate_presence_of(:shares) }
    it { should validate_presence_of(:purchase_price) }
    it { should validate_presence_of(:purchase_date) }

    let(:investment) { create(:investment) }
    it 'is valid with valid attributes' do
      expect(investment).to be_valid
    end

    it 'is not valid without a symbol' do
      investment.symbol = nil
      expect(investment).to_not be_valid
    end

    it 'is not valid without a shares' do
      investment.shares = nil
      expect(investment).to_not be_valid
    end

    it 'is not valid without a purchase_price' do
      investment.purchase_price = nil
      expect(investment).to_not be_valid
    end

    it 'is not valid without a purchase_date' do
      investment.purchase_date = nil
      expect(investment).to_not be_valid
    end
  end

  describe 'attributes' do
    it 'validate factory' do
      expect(FactoryBot.create(:investment)).to be_valid
    end
  end
end
