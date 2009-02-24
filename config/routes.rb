ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => 'intro', :action => 'index'
  map.connect 'intro', :controller => 'intro', :action => 'index'
  map.dashboard 'dashboard', :controller => 'account', :action => 'dashboard'
  map.page 'dashboard/page/:id', :controller => 'account', :action => 'dashboard'
  map.signup_details 'signup/details', :controller => 'signup', :action => 'details_form'
  map.verify 'signup/verify/:token', :controller => 'signup', :action => 'verify_authentication_token'
  map.logout 'logout', :controller => 'account', :action => 'logout'
  map.friend_confirm 'friends/confirm/:id', :controller => 'friends', :action => 'confirm_invitation'
  map.friend_reject 'friends/reject/:id', :controller => 'friends', :action => 'reject_invitation'
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end