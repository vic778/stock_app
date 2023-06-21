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
        row[:cost_of_shares] = investment.number_of_shares * investment.purchase_price
        row[:current_price] = current_price
        row[:gain_or_lost_per_share] = (current_price - investment.purchase_price).round(2)
        row[:total_daily_gain_or_loss] = (row[:gain_or_lost_per_share] * investment.number_of_shares).round(2)
        # row[:current_value] = (row[:cost_of_shares] - row[:total_daily_gain_or_loss]).round(2)
        row[:percentage] = (row[:total_daily_gain_or_loss] / row[:cost_of_shares]) * 100

        if @year.present? && @year.is_a?(Integer) && @year.positive?
          row[:percentage] = (row[:percentage] /= @year).round(2)
          row[:total_daily_gain_or_loss] = (row[:gain_or_lost_per_share] * investment.number_of_shares).round(2) * @year
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
