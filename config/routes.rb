Dooraccess::Application.routes.draw do

  resources :user_certifications

  resources :certifications

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

  resources :users
  match 'users/create' => 'users#create', :via => :post  # Use POST users/create instead of POST users to avoid devise conflict

  match 'cards/upload_all' => 'cards#upload_all', :as => :upload_all
  resources :cards
  match 'cards/:id/upload' => 'cards#upload', :as => :upload

  match 'door_logs' => 'door_logs#index', :as => :door_logs
  match 'door_logs/download' => 'door_logs#download', :as => :download
  match 'door_logs/auto_download' => 'door_logs#auto_download', :as => :auto_download

  match 'macs/scan' => 'macs#scan'
  match 'macs/import' => 'macs#import'
  resources :macs

  resources :mac_logs

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
