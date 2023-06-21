Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
 scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: :sessions, confirmations: :confirmations }, 
                                    path_names: { sign_in: :login }
    resource :user, only: [:update]
    get 'user/auto_login', to: 'users#auto_login'
    get 'users', to: 'users#index'

    resources :portfolios do
      resources :investments
    end
  end
end