Rails.application.routes.draw do
  get 'mine/profile'

  devise_for :users
  root "issues#index"

  resources :issues
  resources :projects do
    post 'assign'
  end

  namespace :apis do 
    get 'issues', to: "issues#index"
    post 'issues', to: "issues#create"
  end
end
