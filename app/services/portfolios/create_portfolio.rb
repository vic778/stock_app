class Portfolios::CreatePortfolio
  attr_accessor :params, :user, :data

  def initialize(params, user)
    @params = params
    @user = user
    @data = user.portfolios.build
  end

  def call
    data.assign_attributes(params)
    data.save ? success_data : failure
  end

  def self.call(params, user)
    new(params, user).call
  end

  def success_data
    { success: true, message: 'Portfolio created successfully', data: }
  end

  def failure
    { success: false, message: 'Portfolio not created', errors: data.errors }
  end
end
