Tracksidentity::Application.routes.draw do

  devise_for :users do
    get "sign_in", :to => "devise/sessions#new", :as => :sign_in
    get "sign_up", :to => "devise/registrations#new", :as => :sign_up
    get "sign_out", :to => "devise/sessions#destroy", :as => :sign_out
  end

  resources :users do
    resources :util_contacts, :only => [:index, :create, :destroy]
    resources :util_emails, :only => [:create, :destroy, :index] do
      get "confirm", :on => :collection
    end
  end
  root :to => "static_pages#home"

end
