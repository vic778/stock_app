require 'rails_helper'
require_relative '../features/sign_in_spec'

RSpec.describe "Portfolios", type: :request do
  context "when as a logged user" do
    before(:each) do
      @current_user = sign_in_user
      @headers = {
        'Content-Type': 'application/json',
        Accept: 'application/json',
        Authorization: "Bearer #{@current_user['token']}",
        uid: @current_user['email']
      }
    end

    describe "CREATE /portfolios" do
      it "returns http success" do
        post "/api/portfolios", params: { name: 'Portfolio 1', description: 'Description 1', user: @current_user }.to_json, headers: @headers
        data = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(data['success']).to eq(true)
        expect(data['message']).to eq('Portfolio created successfully')
        expect(data['data']['name']).to eq('Portfolio 1')
        expect(data['data']['description']).to eq('Description 1')
        expect(data['data']['user_id']).to eq(@current_user['id'])
      end
    end

    describe "GET /portfolios" do
      let!(:portfolio) { create(:portfolio, user_id: @current_user['id']) }
      it "returns http success" do
        get "/api/portfolios", headers: @headers
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(Portfolio.where(user_id: @current_user['id']).size)
      end
    end

    describe "GET /portfolios/:id" do
      let!(:portfolio) { create(:portfolio, user_id: @current_user['id']) }
      it "returns http success" do
        get "/api/portfolios/#{portfolio.id}", headers: @headers
        expect(response).to have_http_status(:success)
      end
    end

    describe "PUT /portfolios/:id" do
      let!(:portfolio) { create(:portfolio, user_id: @current_user['id']) }
      it "returns http success" do
        put "/api/portfolios/#{portfolio.id}", params: { name: 'Portfolio 2', description: 'Description 2' }.to_json, headers: @headers
        data = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(data['success']).to eq(true)
        expect(data['message']).to eq('Portfolio updated successfully')
        expect(data['data']['name']).to eq('Portfolio 2')
        expect(data['data']['description']).to eq('Description 2')
      end
    end
  end

  context "when as a not logged user" do
    describe "GET /portfolios" do
      it "returns http unauthorized" do
        get "/api/portfolios"
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ "message" => "Please log in to continue" })
      end
    end

    describe "GET /portfolios/:id" do
      it "returns http unauthorized" do
        get "/api/portfolios/1"
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ "message" => "Please log in to continue" })
      end
    end

    describe "PUT /portfolios/:id" do
      it "returns http unauthorized" do
        put "/api/portfolios/1"
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ "message" => "Please log in to continue" })
      end
    end
  end
end
