ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'

  # map.upload_file 'jobs/upload_file', :controller => 'jobs', :action => 'upload_file'
  
  
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
  map.root :controller => "sessions", :action=>"new"
  
  map.connect 'session/new/:id', :controller => 'sessions', :action => 'new'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  
  map.resource :session
  map.resources :commands, :has_many => [:jobs]
  
#  map.upload_stage 'commands/:command_id/jobs/upload_stage.:format', :controller => 'jobs', :action => 'upload_stage'

  map.upload_stage 'commands/:command_id/jobs/:job_id/stage/:stage.:format', :controller => 'jobs', :action => 'create',:conditions => { :method => :post }
#  map.upload_stage 'commands/:command_id/jobs/new/:stage.:format', :controller => 'jobs', :action => 'create',:conditions => { :method => :post }

  map.connect 'commands/:command_id/jobs/new/:stage.:format', :controller => 'jobs', :action => 'new',:conditions => { :method => :get }
  map.connect 'commands/:command_id/jobs/:job_id/stage/:stage.:format', :controller => 'jobs', :action => 'new',:conditions => { :method => :get }


#  map.job_list 'commands/:command_id/jobs/job_list', :controller => 'jobs', :action => 'index'

  
  #map.resource :test1
  
  #map.resource :jobs
  
  #map.resource :joblist
  
  #map.resource :download
  map.download_job 'downloads/:command_id/:job_id.:format', :controller => 'downloads', :action => 'download'
  map.download 'downloads/:command_id/:job_id/:file_id.:format', :controller => 'downloads', :action => 'download' , :requirements => { :file_id => /.*/}
#  map.download_img 'downloads/:command_id/:job_id/:file_id.:format', :controller => 'downloads', :action => 'download_img' , :requirements => { :file_id => /.*/}

  #map.resources :commands, :has_many => [ :comments, :sales ], :has_one => :seller
  
   #  map.connect ':command/:work/:controller/:action/:id', :requirements => { :id => /.*/, :command => /.*/, :work => /.*/ }
   # bueno:
   
  map.connect ':controller/:action/:id'
 #  map.connect ':controller/:action/:id.:format'
  
end
