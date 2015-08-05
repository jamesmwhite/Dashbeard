Rails.application.routes.draw do
  resources :stock_settings

  resources :photo_links

  resources :data_caches

  resources :settings

  root 'static_pages#home'

  get '/train/', to: 'train#station'
  get '/bus/', to: 'bus#station'
  get '/stock/', to: 'stock#quote'
  get '/rss/', to: 'rss#feed'
  get '/notices/', to: 'settings#listNotices'
  get '/clearcache/', to: 'data_caches#clearAll'
  get '/setMessage/', to: 'static_pages#setMessage'
  get '/setImage/', to: 'static_pages#setImg'
  get '/checkRefresh/', to: 'static_pages#checkRefresh'
  get '/forceRefresh/', to: 'static_pages#forceRefresh'
  get '/getImages/', to: 'photo_links#getImages'
  get '/getPhotoRefresh/', to: 'settings#getPhotoRefresh'
  get '/getContentRefreshTime/', to: 'settings#getContentRefreshTime'


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
