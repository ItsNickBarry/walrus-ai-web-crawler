Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'pages#root'

  namespace :api, defaults: { format: :json } do
    resources :web_pages, only: [:index]
    resources :uniform_resource_identifiers, only: [:index]
  end
end
