require 'rails_helper'

RSpec.describe "Users", type: :request do
  context "when as a confirmed account" do
    let!(:user) { create(:user) }

    describe "LOGIN /login" do
      it "logs in a user" do
        post "/api/users/login", params: { user: { email: user.email, password: user.password, confirmed_at: Time.now } }
        data = JSON.parse(response.body)
        expect(data["user"]["name"]).to eq(user.name)
        expect(data["user"]["email"]).to eq(user.email)
        expect(data["user"]["token"]).to eq(user.generate_jwt)
      end

      it "returns an error if the email is invalid" do
        post "/api/users/login", params: { user: { email: "invalid", password: user.password } }
        data = JSON.parse(response.body)
        expect(data["errors"]["email or password"]).to eq(["is invalid"])
      end
    end
  end

  context "when as an unconfirmed account" do
    let!(:user) { create(:user) }

    describe "LOGIN /login" do
      it "returns an error if the account is not confirmed" do
        post "/api/users/login", params: { user: { email: user.email, password: user.password } }
        data = JSON.parse(response.body)
        expect(data["message"]) == ("Please confirm your registered email to access your account.")
      end
    end
  end
end
