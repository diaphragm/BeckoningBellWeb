Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get '/', to:'bells#new'
  get '/bells/cleanup', to: 'bells#cleanup'

  resources :bells do
    resources :messages
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
