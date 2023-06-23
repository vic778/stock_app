module Portfolios
  class DailyReportService
    attr_accessor :portfolio, :array, :params

    def initialize(portfolio, params = {})
      @portfolio = portfolio
      @array = []
      @format = params[:format]
      @year = params[:year].to_i || Date.today.year
      @format = 'json'
    end

    def call
      { data: send(@format) }
    end

    def json
      @portfolio.investments.each do |investment|
        current_price = fetch_market_data(investment.symbol)[:current_price]

        row = {}
        row[:symbol] = investment.symbol
        row[:purchase_price] = investment.purchase_price
        row[:number_of_shares] = investment.number_of_shares
        row[:total_investement] = investment.number_of_shares * investment.purchase_price # get the total amount of investment for shares
        row[:current_price] = current_price # get the current price of the share from the api
        row[:current_total_price] = investment.number_of_shares * row[:current_price]

        # get the gain or lost, the formula is current_total_price - total_investement
        row[:gain_or_lost] = (row[:current_total_price] - row[:total_investement]).round(2)
        # get the percentage, the formula is gain_or_lost / total_investement * 100
        # if you want to check if the amount is correct, you can do
        # the total_investement * percentage / 100 and it should be equal to gain_or_lost
        row[:percentage] = ((row[:gain_or_lost] / row[:total_investement]) * 100).round(2)

        if @year.present? && @year.is_a?(Integer) && @year.positive?
          row[:percentage] = (row[:percentage] /= @year).round(2) # divide the percentage by the year
          row[:gain_or_lost] = (row[:gain_or_lost] * row[:number_of_shares]) * @year
        end

        array << row
      end
      array
    end

    def csv
      CSV.generate do |csv|
        csv << ["GOSCORE"]
        csv << ["Portfolio Daily Report"]
        csv << ["Date: #{Date.today}"]
        json.each do |key, value|
          csv << [key, value]
        end
      end
    end

    protected

    def fetch_market_data(symbol)
      market_data_service = MakingApi::MarketDataService.new(ENV.fetch('alpha_key', nil))
      market_data_service.fetch_market_data(symbol)
    end
  end
end
