Rails.application.routes.draw do
  devise_for :users
  resources :users, only: :show
  resources :groups, shallow: true do
    resources :products do
      collection do
        get 'create_title'
        #get 'top'
      end
      resources :comments
    end
    collection do
      get 'search_group'
      get 'search_top'
      get 'search_group_top'
      # get 'intro'
    end
  end
  get 'products' => 'products#index_all'
  get 'products/:id/comments/:id/add' => 'comments#add'
  post 'products/dl_test' => 'products#dl_test'
  # post 'products/:id/likes' => 'likes#create'
  # delete 'products/:id/likes' => 'likes#destroy'
  post 'products/:id/comments/:id/likes' => 'likes#create'
  delete 'products/:id/comments/:id/likes' => 'likes#destroy'

  post 'products/download_db' => 'products#download_db'
  get '/intro' => 'groups#intro'

  #get 'groups/intro' => 'groups#intro'

  # resources :groups
  # resources :products do
  #   collection do
  #     get 'create_title'
  #     #get 'top'
  #   end
  # end
  root 'groups#top'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
