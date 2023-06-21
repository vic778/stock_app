# require 'rails_helper'
# require_relative '../features/sign_in_spec'

# RSpec.describe 'DailyReportService' do
#     let(:portfolio) { create(:portfolio) }
#     let(:service) { described_class.new(portfolio) }

#     describe '#call' do
#       it 'returns the formatted data' do
#         allow(service).to receive(:json).and_return([{ symbol: 'AAPL', purchase_price: 100 }])
#         expect(service.call).to eq({ data: [{ symbol: 'AAPL', purchase_price: 100 }] })
#       end
#     end

#     describe '#json' do
#       let!(:investment) { create(:investment, portfolio: portfolio, symbol: 'AAPL', purchase_price: 100, number_of_shares: 5) }

#       before do
#         allow(service).to receive(:fetch_market_data).with('AAPL').and_return({ current_price: 110 })
#       end

#       it 'returns the investment data' do
#         expect(service.json).to eq([{ symbol: 'AAPL', purchase_price: 100, number_of_shares: 5, cost_of_shares: 500, current_price: 110, gain_or_lost_per_share: 10.0, total_daily_gain_or_loss: 50.0, percentage: 10.0 }])
#       end
#     end
#   end
