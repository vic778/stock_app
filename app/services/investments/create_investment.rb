module Investments
  class CreateInvestment
    attr_accessor :params, :portfolio, :result

    def initialize(params, portfolio)
      @params = params
      @portfolio = portfolio
      @result = Struct.new(:success, :errors, :investment)
    end

    def call
      investment = portfolio.investments.build(params)
      investment.purchase_date = DateTime.current
      if investment.save
        result.new(true, nil, investment)
      else
        result.new(false, investment.errors.full_messages, nil)
      end
    end

    class << self
      def call(params, portfolio)
        new(params, portfolio).call
      end
    end
  end
end
