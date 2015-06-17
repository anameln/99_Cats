Cats::Application.routes.draw do

  resources :cats
  resources :cat_rental_requests do
    member do
      post 'approve'
      post 'deny'
    end
  end

  resources :users
  resource :session, only: [:create, :destroy, :new]

end
