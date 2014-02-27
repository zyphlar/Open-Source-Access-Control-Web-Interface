Dooraccess::Application.routes.draw do
  match 'ipns/import' => 'ipns#import', :as => :import_ipn
  resources :ipns
  match 'ipns/:id/link' => 'ipns#link', :as => :link_ipn
  match 'ipns/:id/validate' => 'ipns#validate', :as => :validate_ipn

  resources :paypal_csvs
  match 'paypal_csvs/:id/link' => 'paypal_csvs#link', :as => :link_paypal_csv

  resources :payments
  resources :resources
  resources :resource_categories, except: :show

  match 'statistics' => 'statistics#index', :as => :statistics
  match 'statistics/mac_log' => 'statistics#mac_log', :as => :mac_statistics
  match 'statistics/door_log' => 'statistics#door_log', :as => :door_statistics

  resources :user_certifications

  resources :certifications

  resources :contracts

  devise_for :users, :skip => :registrations
  devise_scope :user do
    resource :registration,
      :only => [:new, :create, :edit, :update],
      :path => 'users',
      :path_names => { :new => 'sign_up' },
      :controller => 'registrations',
      :as => :user_registration do
        get :cancel
      end
  end

  match 'user_summary/:id' => 'users#user_summary' # User summary view
  match 'users/activity' => 'users#activity' # User activity
  match 'users/new_member_report' => 'users#new_member_report' # New member report (For emailing)
  match 'users/merge' => 'users#merge_view', :via => :get # Merge view
  match 'users/merge' => 'users#merge_action', :via => :post # Merge action
  match 'users/inactive' => 'users#inactive' # Inactive users report
  resources :users do 
    get 'email' => 'users#compose_email', :as => "compose_email"
    post 'email' => 'users#send_email'
  end
  match 'users/create' => 'users#create', :via => :post  # Use POST users/create instead of POST users to avoid devise conflict

  match 'cards/upload_all' => 'cards#upload_all', :as => :upload_all
  match 'cards/authorize/:id' => 'cards#authorize', :as => :authorize
  resources :cards
  match 'cards/:id/upload' => 'cards#upload', :as => :upload

  match 'space_api' => 'space_api#index', :as => :space_api
  match 'space_api/access' => 'space_api#access', :via => :get, :as => :space_api_access
  match 'space_api/access' => 'space_api#access_post', :via => :post

  match 'door_logs' => 'door_logs#index', :as => :door_logs
  match 'door_logs/download' => 'door_logs#download', :as => :download
  match 'door_logs/auto_download' => 'door_logs#auto_download', :as => :auto_download

  match 'macs/scan' => 'macs#scan'
  match 'macs/import' => 'macs#import'
  match 'macs/history' => 'macs#history'
  resources :macs
  resources :mac_logs

  resources :settings, :only => [:index, :edit, :update]

  match 'more_info' => 'home#more_info'
  root :to => "home#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
