App::Application.routes.draw do

  get 'issues/:id/resolve' => 'issues#resolve', :as => "resolve"
  get 'issues/:id/assign' => 'issues#assign', :as => "assign"
  get 'issues/:id/unassign' => 'issues#unassign', :as => "unassign"

  get 'issues/:id/voteup' => 'issues#voteup', :as => "voteup"
  get 'issues/:id/votedown' => 'issues#votedown', :as => "votedown"

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'

  get 'indexadmin' => 'users#indexadmin'
  get 'oncall/:id' => 'users#toggle_oncall', :as => 'oncall'

  post 'issues/:id/answer' => 'responses#answer'

  match '/auth/github/callback', :to => "sessions#github"

  get 'big_board' => 'issues#big_board'

  get "theme" => "issues#theme", :as => "theme"

  get 'users/:id/admin' => 'users#admin', :as => "makeadmin"
  get 'users/:id/notadmin' => 'users#notadmin', :as => "removeadmin"

  resources :users

  resources :issues

  resources :sessions

  resources :responses

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
  root :to => 'issues#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
