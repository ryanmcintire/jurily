Rails.application.routes.draw do
  get 'hello_world', to: 'hello_world#index'
  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}

  resources :answers
  resources :questions
  resources :answer, only: [:create]
  resources :users do
    resources :lawschool_details, except: [:show, :index]
  end
  resources :bar_admissions, except: [:show]

  get 'hello_world', to: 'hello_world#index'

  get 'new_profile', to: 'users#new_profile', as: 'new_profile'
  post 'create_profile', to: 'users#create_profile', as: 'create_profile'

  post 'vote', to: 'votes#vote', as: 'vote', defaults: {:format => :json}
  get 'vote', to: 'votes#get_vote', as: 'get_vote', defaults: {:format => :json}

  get 'search', to: 'search#search', as: 'search'

  get 'top_answers', to: 'welcome#top_answers', as: 'top_answers'
  get 'top_questions', to: 'welcome#top_questions', as: 'top_questions'
  get 'recent_answers', to: 'welcome#recent_answers', as: 'recent_answers'
  get 'recent_questions', to: 'welcome#recent_questions', as: 'recent_questions'


  root to: 'welcome#home'


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
