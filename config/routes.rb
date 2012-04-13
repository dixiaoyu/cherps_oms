Challenger2::Application.routes.draw do
  
  root :to => 'sessions#new'
  #root :to => 'sessions#new'
  
  resources :crm_member_lists
  resources :sessions, :only => [:new, :create, :destroy]

 
  resources :crm_member_lists do
    resources :crm_redemption_reservations
  end

  resources :crm_redemption_reservations
  
  resources :crm_product_lists do
    resources :crm_product_reservations
  end
  
  resources :crm_redemption_locations  
  resources :ims_inv_physicals
  
  resources :crm_redemption_lists do    
    resources :crm_redemption_reservations
  end
  
  resources :crm_workshop_lists do    
    resources :crm_workshop_reservations
  end
  
  
  

  
  match '/signin' => 'sessions#new', :as=>:signin
  match '/signout' => 'sessions#destroy'
  
  match '/signup' => 'crm_member_lists#new' ,:as=> :signup
  match '/crm_member_lists/:id' =>'crm_member_lists#show', :as => :home
  match '/changepw' =>'crm_member_lists#changepw', :as => :changepw
  match '/updatepassword' =>'crm_member_lists#updatepw', :as => :changepassword
  match '/changesuccess' =>'crm_member_lists#pwsuccess', :as => :pwdsuccess
  match '/welcome' =>'crm_member_lists#welcome', :as => :welcome
  match '/invalid' =>'crm_member_lists#invalid', :as => :invalid
  match '/activeaccount/:id/:code' =>'crm_member_lists#activeaccount', :as => :activeaccount
  match '/forgetpassword' =>'crm_member_lists#forgetpw', :as => :forget
  match '/submitemail' =>'crm_member_lists#checkemail', :as => :checkemail
  
  match '/crm_redemption_lists' => 'crm_redemption_lists#index', :as => :redemption
  match '/crm_redemption_lists/:id' => 'crm_redemption_lists#show', :as => :redeemdetails  
  
  match '/crm_redemption_lists/:id/crm_redemption_reservations/:id' => 'crm_redemption_reservations#show', :as => :reservation
  match '/redemption_receipt' => 'crm_redemption_reservations#detail', :as => :redeemreceipt
  match '/crm_redemption_reservations' => 'crm_redemption_reservations#index', :as => :redeemhistory
  match '/rebate' => 'crm_redemption_reservations#rebate', :as => :rebate
  match '/destroy/:id' => 'crm_redemption_reservations#destroy' , :as => :destroy
 # match '/crm_redemption_locations' =>'crm_redemption_locations#index', :as => :location_1
  
  match '/redemption_locations' =>'ims_inv_physicals#index', :as => :location
  
  match '/detail/:id' => 'crm_member_lists#detail' , :as => :detail
  match '/change/:id' => 'crm_member_lists#change' , :as => :change
  match '/status/:id' => 'crm_member_lists#statuscheck' , :as => :status
  match '/renew/:id' => 'crm_member_lists#renew' , :as => :renew
  
  match '/crm_member_transactions' => 'crm_member_transactions#index' , :as => :transaction
  match '/transaction_filter' => 'crm_member_transactions#filter' , :as => :filter 
  match '/purchase' => 'crm_member_transactions#purchaselist' , :as=>:purchaselist 
  
  match '/feedback' => 'feedbacks#index' , :as=>:feedback
  match '/feedbacktype' => 'feedbacks#fbtype' , :as=>:feedbacktype
  match '/purchasefeedback' => 'feedbacks#transfeedback', :as=>:transfeedback  
  match '/createfeedback' => 'feedbacks#create_feedback', :as=>:createfeedback
  match '/thanks' => 'feedbacks#thanks', :as=>:thanks
  
  match '/login_failed' => 'crm_login_faileds#loginfailed', :as=>:failed
  match '/resetpw/:id/:code' => 'crm_login_faileds#resetpw', :as=>:resetpw
  match '/renewpwd' => 'crm_login_faileds#renewpw', :as=>:renewpw
  match '/pwsuccessfully_reset' => 'crm_login_faileds#renewsuccess', :as=>:pwsuccess
  
  #PRODUCT RESERVATION
  match '/product' => 'crm_product_lists#index', :as=>:productlist
  match '/productdetails' => 'crm_product_lists#show', :as=>:productdetail
  match '/filterproducts' => 'crm_product_lists#filter', :as=>:filterproduct
  match '/crm_product_lists/:id/crm_product_reservations/:id' => 'crm_product_reservations#show', :as => :productreserve
  match '/productdestroy/:id' => 'crm_product_reservations#destroy' , :as => :productdestroy
  #match '/crm_redemption_lists/:id' => 'crm_redemption_lists#show' ,:as => :redeemdetails
  #resources :crm_member_transactions,:only => [:index, :show]
  
  
  #WORKSHOP RESERVATION
  match '/workshop' => 'crm_workshop_lists#index', :as=>:workshoplist
  match '/workshopdetails' => 'crm_workshop_lists#show', :as=>:workshopdetail
  match '/crm_workshop_lists/:id/crm_workshop_reservations/:id' => 'crm_workshop_reservations#show', :as => :workshopreserve
  match '/workshopdestroy/:id' => 'crm_workshop_reservations#destroy' , :as => :workshopdestroy
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
  # match ':controller(/:action(/:id(.:format)))'
end
