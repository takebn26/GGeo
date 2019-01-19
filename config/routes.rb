Rails.application.routes.draw do
  root 'buildings#index'
  resources :buildings, only: %i[new create]
end
