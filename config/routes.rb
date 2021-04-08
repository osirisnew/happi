Rails.application.routes.draw do
  devise_for :users

  authenticate :user, ->(u) { u.role?(:admin) } do
    mount Sidekiq::Web => "/sidekiq"
  end

  resources :custom_email_addresses, only: %i[create destroy]
  resources :customers
  resources :message_threads, only: %i[index show new create update destroy], path: "threads" do
    resources :messages, only: %i[new create]
  end
  resources :teams, only: %i[index new create] do
    post :change, on: :member
  end
  resource :settings, only: %i[show update]
  get "/join/:code", to: "team_invites#new", as: :join_team
  post "/join/:code", to: "team_invites#create"
  put "/join/:code", to: "team_invites#update"

  root to: "dashboard#show"
end
