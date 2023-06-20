require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:password_confirmation) }

  describe "attributes" do
    it "validate factory" do
      expect(FactoryBot.create(:user)).to be_valid
    end
  end

  describe "instance methods" do
    let(:user) { FactoryBot.create(:user) }

    it "responds to requires_confirmation?" do
      expect(user).to respond_to(:requires_confirmation?)
    end

    it "responds to generate_jwt" do
      expect(user).to respond_to(:generate_jwt)
    end
  end

  describe "class methods" do
    it "responds to find_for_database_authentication" do
      expect(User).to respond_to(:find_for_database_authentication)
    end
  end

  # describe "associations" do
  #   it "has many transactions" do
  #     expect(User.reflect_on_association(:transactions).macro).to eq(:has_many)
  #   end
  # end

  describe "validations" do
    let(:user) { FactoryBot.create(:user) }
    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is not valid without a first_name" do
      user.name = nil
      expect(user).to_not be_valid
    end

    it "is not valid without a email" do
      user.email = nil
      expect(user).to_not be_valid
    end

    it "is not valid without a password" do
      user.password = nil
      expect(user).to_not be_valid
    end

    it "is not valid without a password_confirmation" do
      user.password_confirmation = nil
      expect(user).to_not be_valid
    end
  end
end
