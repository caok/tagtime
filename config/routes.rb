Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root "issues#index"

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  get 'mine/profile'
  resources :issues do 
    get 'load_more', on: :collection
  end

  resources :projects do
    post 'assign'
    get 'name_list', on: :collection
    delete 'destroy_member', on: :member
    post 'revoke_manager_right', on: :member
    post 'give_manager_right', on: :member
    get 'users', on: :collection
  end

  controller :report do
    get 'report/summary', action: :summary, as: :report_summary
    get 'report/:project/detail', action: :detail, as: :report_detail
  end

  namespace :apis do 
    get 'issues', to: "issues#index"
    get 'timelist', to: "issues#timelist"
    get 'projects', to: "issues#projects"
    post 'issues', to: "issues#create"
    post 'login', to: "base#login"
    post 'authorize', to: "base#authorize"

    post 'push', to: "github#push"
  end
end
