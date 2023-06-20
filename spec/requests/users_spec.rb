require 'rails_helper'

RSpec.describe "Users", type: :request do
  context "when as a user" do
    let!(:user) { create(:user) }

    describe "CREATE /users" do
      it "creates a user" do
        post users_path, params: { user: { name: "Test", email: "test@gmail.com", password: "password", password_confirmation: "password" } }
        data = JSON.parse(response.body)
        expect(data["title"]).to eq("Registration Successful")
        expect(data["message"]).to eq("Thank you for joining the GOSCORE platform, please check your email and verify your account!")
      end
    end

    describe "PUT /users/:id" do
      it "updates a user" do
        put user_path(user)
        expect(response).to have_http_status(200)
      end
    end
  end
end
