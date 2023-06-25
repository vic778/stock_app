class HomeController < ApplicationController
  def index
    symbol = home_params[:symbol] || 'AAPL'
    market_data = MakingApi::MarketDataService.new(ENV.fetch('alpha_key')).fetch_historical_data(symbol)
    render json: { data: market_data }
  end

  protected

  def home_params
    params.permit(:symbol)
  end
end
