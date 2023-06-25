require 'net/http'
require 'json'

class MakingApi::MarketDataService
  def initialize(api_key)
    @api_key = api_key
  end

  def fetch_market_data(symbol)
    url = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{symbol}&apikey=#{@api_key}"
    response = Net::HTTP.get(URI.parse(url))
    data = JSON.parse(response)

    if data['Global Quote'].present?
      # Extract the required market data from the response
      current_price = data['Global Quote']['05. price'].to_f
      market_status = data['Global Quote']['07. latest trading day']
      change_percent = data['Global Quote']['10. change percent']

      # Return the market data
      { current_price:, market_status: }
    else
      # Handle the case when the API does not provide the expected data
      { error: 'Unable to fetch market data' }
    end
  end

  def fetch_historical_data(symbol)
    url = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=#{symbol}&apikey=#{@api_key}"
    response = Net::HTTP.get(URI.parse(url))
    data = JSON.parse(response)

    stock_chartx_values_function = []
    stock_charty_values_function = []

    if data['Time Series (Daily)'].present?
      data['Time Series (Daily)'].each do |key, value|
        stock_chartx_values_function << key
        stock_charty_values_function << value['1. open']
      end
    end

    { stockChartXValues: stock_chartx_values_function, stockChartYValues: stock_charty_values_function }
  end
end
