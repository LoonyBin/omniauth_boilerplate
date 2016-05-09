OmniauthBoilerplate::Engine.routes.draw do
  match '/:provider/callback' => 'authentications#create', via: [:get, :post], as: :omniauth_callback
  resources :authentications, only: [:index, :new, :destroy]
end
