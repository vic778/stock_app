require 'rails_helper'
require_relative '../features/sign_in_spec'

RSpec.describe "Investments", type: :request do
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

    describe "CREATE /portfolios/:portfolio_id/investments" do
      let!(:portfolio) { create(:portfolio, user_id: @current_user['id']) }
      it "returns http success" do
        post "/api/portfolios/#{portfolio.id}/investments", params: { symbol: 'AAPL', number_of_shares: 10, purchase_price: 100, purchase_date: '2021-01-01' }.to_json, headers: @headers
        data = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(data['symbol']).to eq('AAPL')
        expect(data['number_of_shares']).to eq(10)
        expect(data['purchase_price']).to eq(100)
        expect(data['purchase_date']).to eq(data['purchase_date'])
        expect(data['portfolio_id']).to eq(portfolio.id)
      end
    end

    describe "GET /portfolios/:portfolio_id/investments" do
      let!(:portfolio) { create(:portfolio, user_id: @current_user['id']) }
      let!(:investment) { create(:investment, portfolio_id: portfolio.id) }
      it "returns http success" do
        get "/api/portfolios/#{portfolio.id}/investments", headers: @headers
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(portfolio.investments.size)
      end
    end

    describe "GET /portfolios/:portfolio_id/investments/:id" do
      let!(:portfolio) { create(:portfolio, user_id: @current_user['id']) }
      let!(:investment) { create(:investment, portfolio_id: portfolio.id) }
      it "returns http success" do
        get "/api/portfolios/#{portfolio.id}/investments/#{investment.id}", headers: @headers
        expect(response).to have_http_status(:success)
      end
    end

    describe "PUT /portfolios/:portfolio_id/investments/:id" do
      let!(:portfolio) { create(:portfolio, user_id: @current_user['id']) }
      let!(:investment) { create(:investment, portfolio_id: portfolio.id) }
      it "returns http success" do
        put "/api/portfolios/#{portfolio.id}/investments/#{investment.id}", params: { symbol: 'AAPL', number_of_shares: 10, purchase_price: 100, purchase_date: '2021-01-01' }.to_json, headers: @headers
        data = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(data['status']).to eq(true)
        expect(data['message']).to eq('Investment updated successfully')
        expect(data['data']['symbol']).to eq('AAPL')
        expect(data['data']['number_of_shares']).to eq(10)
        expect(data['data']['purchase_price']).to eq(100)
        expect(data['data']['purchase_date']).to eq(data['data']['purchase_date'])
        expect(data['data']['portfolio_id']).to eq(portfolio.id)
      end
    end

    describe "DELETE /portfolios/:portfolio_id/investments/:id" do
      let!(:portfolio) { create(:portfolio, user_id: @current_user['id']) }
      let!(:investment) { create(:investment, portfolio_id: portfolio.id) }
      it "returns http success" do
        delete "/api/portfolios/#{portfolio.id}/investments/#{investment.id}", headers: @headers
        data = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(data['status']).to eq(true)
        expect(data['message']).to eq('Investment deleted successfully')
      end
    end
  end

  context "when as a not logged user" do
    describe "GET /portfolios/:portfolio_id/investments" do
      let!(:portfolio) { create(:portfolio) }
      it "returns http success" do
        get "/api/portfolios/#{portfolio.id}/investments"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "GET /portfolios/:portfolio_id/investments/:id" do
      let!(:portfolio) { create(:portfolio) }
      let!(:investment) { create(:investment, portfolio_id: portfolio.id) }
      it "returns http success" do
        get "/api/portfolios/#{portfolio.id}/investments/#{investment.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "PUT /portfolios/:portfolio_id/investments/:id" do
      let!(:portfolio) { create(:portfolio) }
      let!(:investment) { create(:investment, portfolio_id: portfolio.id) }
      it "returns http success" do
        put "/api/portfolios/#{portfolio.id}/investments/#{investment.id}", params: { symbol: 'AAPL', number_of_shares: 10, purchase_price: 100, purchase_date: '2021-01-01' }.to_json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "DELETE /portfolios/:portfolio_id/investments/:id" do
      let!(:portfolio) { create(:portfolio) }
      let!(:investment) { create(:investment, portfolio_id: portfolio.id) }
      it "returns http success" do
        delete "/api/portfolios/#{portfolio.id}/investments/#{investment.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
