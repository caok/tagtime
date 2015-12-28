Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }
  root "issues#index"

  get 'mine/profile'
  resources :issues
  resources :projects do
    post 'assign'
    get 'name_list', on: :collection
  end

  namespace :apis do 
    get 'issues', to: "issues#index"
    get 'timelist', to: "issues#timelist"
    get 'projects', to: "issues#projects"
    post 'issues', to: "issues#create"
    post 'login', to: "base#login"
    post 'authorize', to: "base#authorize"
  end
end
