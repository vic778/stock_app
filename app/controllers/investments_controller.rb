class InvestmentsController < PermissionsController
  before_action :authenticate_user!
  before_action :set_investment, only: %i[show update destroy]
  before_action :set_portfolio

  def index
    @investments = @portfolio.investments.all
    render json: @investments
  end

  def show
    render json: @investment
  end

  def create
    data = Investments::CreateInvestment.new(investment_params, set_portfolio).call
    if data.success
      render json: data.investment, status: :created
    else
      render json: { errors: data.errors }, status: :unprocessable_entity
    end
  end

  def update
    render json: { status: true, message: 'Investment updated successfully', data: @investment } if @investment.update(investment_params)
  end

  def destroy
    render json: { status: true, message: 'Investment deleted successfully' } if @investment.destroy
  end

  private

  def set_investment
    @investment = set_portfolio.investments.find(params[:id])
  end

  def set_portfolio
    @portfolio = Portfolio.find(params[:portfolio_id])
  end

  def investment_params
    params.permit(:symbol, :number_of_shares, :purchase_price, :purchase_date, :portfolio_id)
  end
end
