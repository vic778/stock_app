require 'rails_helper'

RSpec.describe Portfolio, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:investments).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }

    let(:portfolio) { create(:portfolio) }
    it 'is valid with valid attributes' do
      expect(portfolio).to be_valid
    end

    it 'is not valid without a name' do
      portfolio.name = nil
      expect(portfolio).to_not be_valid
    end

    it 'is not valid with a duplicate name' do
      portfolio2 = build(:portfolio, name: portfolio.name)
      expect(portfolio2).to_not be_valid
    end
  end
end
