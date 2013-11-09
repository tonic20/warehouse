Warehouse::Application.routes.draw do |map|
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'login' => 'user_sessions#new', :as => :login

  resources :user_sessions

  resources :equipments
  resources :categories
  resources :stocks
  resources :stock_items

  resources :users do
    member do
      get :change_password
    end
  end

  match 'reports' => "reports#equipment", :as => :reports_root
  match 'reports/equipment' => "reports#equipment", :as => :reports_equipment
  match 'reports/equipment_summary' => "reports#equipment_summary", :as => :reports_equipment_summary
  match 'reports/equipment_history/:id' => "reports#equipment_history", :as => :reports_equipment_history

  match 'help' => "help#index", :as => :help

  match 'admin' => "equipments#index", :as => :admin_root

  root :to => "stock_items#index"
end

