Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  resources :scores, only: [:index]

  get 'rooms/show'
  get 'rooms', to: 'rooms#show'

  get 'challenges/:id/', to: 'challenges#index'
  get 'challenges/:id/:component', to: 'challenges#show'

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
end
