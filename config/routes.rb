Rails.application.routes.draw do
  resources :bells do
    resources :messages
  end

  get '/', to:'bells#new'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
