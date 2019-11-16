Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get '/', to:'bells#new'
  get 'admin/cleanup', to: 'maintenance#cleanup'

  resources :bells do
    resources :messages
  end

  match '*path' => 'application#_render_404', via: :all

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
