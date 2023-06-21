class Portfolios::EditPortfolio
  attr_accessor :params, :user, :data

  def initialize(params, user, data)
    @params = params
    @user = user
    @data = data
  end

  def call
    data.update(params)
    data.save ? success_data : failure
  end

  def self.call(params, user)
    new(params, user).call
  end

  def success_data
    { success: true, message: 'Portfolio updated successfully', data: }
  end

  def failure
    { success: false, message: 'Portfolio not updated', errors: data.errors }
  end
end
