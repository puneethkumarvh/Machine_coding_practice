Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post 'users/create', to: 'users#create'
  post 'loans/create', to: 'loans#create'
  get 'loans/show', to: 'loans#show'
  post 'loans/make_payment', to: 'loans#make_payment'
  get 'loans/all_loans', to: 'loans#all_loans'
  get 'loans/payment_schedule', to: 'loans#payment_schedule' # New route
end
