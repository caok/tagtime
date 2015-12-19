Rails.application.routes.draw do
  devise_for :users
  root "issues#index"

  resources :issues

  namespace :apis do 
    get 'issues', to: "issues#index"
    post 'issues', to: "issues#create"
  end
end
