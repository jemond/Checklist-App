Cla::Application.routes.draw do
	root :to => "pages#index"

	resources :checklists
	
	# handling checklists
	match 'checklists/:id/checkoff' => 'checklists#checkoff'
	match 'checklists/:id/finish' => 'checklists#finish'
	match 'checklists/:id/abandon' => 'checklists#abandon'
	match 'about' => 'pages#about'
	match 'samples' => 'pages#samples'
	
	# hack up the devise route, which is fucking painful to do
	# http://stackoverflow.com/questions/5180295/how-to-change-the-login-and-signup-urls-in-devise-plugin-rails3
	devise_for :users,
		:controllers => { :sessions => 'devise/sessions'},
		:skip => [:sessions] do
			get '/login' => 'devise/sessions#new', :as => :new_user_session
			post '/login' => 'devise/sessions#create', :as => :user_session
			get '/logout' => 'devise/sessions#destroy', :as => :destroy_user_session
	end

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
	# root :to => "welcome#index"
	
	# See how all your routes lay out with "rake routes"
	
	# This is a legacy wild controller route that's not recommended for RESTful applications.
	# Note: This route will make all actions in every controller accessible via GET requests.
	# match ':controller(/:action(/:id(.:format)))'
  
end
