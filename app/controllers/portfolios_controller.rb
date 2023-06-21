class PortfoliosController < PermissionsController
  before_action :authenticate_user!
  before_action :set_portfolio, only: %i[show update destroy]

  def index
    portfolios = current_user.portfolios
    render json: portfolios
  end

  def show
    market_data = Portfolios::DailyReportService.new(@portfolio).call
    render json: { portfolio: @portfolio, historical_data: market_data.first }
  end

  def create
    result = Portfolios::CreatePortfolio.call(portfolio_params, current_user)
    if result[:success]
      render json: { success: result[:success], message: result[:message], data: result[:data] }, status: :created
    else
      render json: { success: result[:success], message: result[:message], errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def update
    result = Portfolios::EditPortfolio.new(portfolio_params, current_user, @portfolio).call
    if result[:success]
      render json: { success: result[:success], message: result[:message], data: result[:data] }, status: :ok
    else
      render json: { success: result[:success], message: result[:message], errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def destroy
    @portfolio.destroy
    render json: { success: true, message: 'Portfolio deleted successfully' }, status: :ok
  end

  protected

  def set_portfolio
    @portfolio = current_user.portfolios.find_by_id(params[:id])
    render json: { success: false, message: 'Portfolio not found' } unless @portfolio.present?
  end

  def portfolio_params
    params.permit(:name, :description)
  end
end
