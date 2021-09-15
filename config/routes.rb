Rails.application.routes.draw do
  namespace :admin do
    resources :teams
    resources :users
    resources :custom_email_addresses
    resources :beta_signups

    root to: "teams#index"
  end

  namespace :events do
    post "/postmark", to: "postmark_webhooks#create"
  end

  namespace :api, format: :json do
    scope path: ":team_publishable_key" do
      resources :customers, only: :create
      resources :messages, only: :create
    end
  end

  devise_for :users, controllers: { masquerades: "admin/masquerades" }

  authenticated :user, ->(u) { u.role?(:admin) } do
    mount Sidekiq::Web => "/sidekiq"
    mount Blazer::Engine, at: "blazer"
  end

  # Stripe webhooks
  mount StripeEvent::Engine, at: "/events/stripe"

  resources :beta_signups, only: :create
  namespace :billing do
    resource :subscriptions, path: "subscription", only: %i[show create]
    get :success, to: "subscriptions#success"
    post :manage, to: "subscriptions#manage"
  end
  resources :canned_responses, only: %i[new create edit update destroy]
  resources :custom_email_addresses, only: %i[create destroy]
  resources :customers do
    post "block", on: :member
    post "unblock", on: :member
  end
  resources :message_threads, only: %i[index show new create update destroy], path: "threads" do
    post :merge_with_previous, on: :member
    resources :messages, only: %i[new create] do
      get :hovercard, on: :member
    end
  end
  resources :teams, only: %i[index new create edit update] do
    post :change, on: :member
    put :logo_upload, on: :member
  end
  resource :settings, only: %i[show update] do
    get :team
    get :emails
    get :canned_responses
    get :widget
    get :billing
  end
  get "/join/:code", to: "team_invites#new", as: :join_team
  post "/join/:code", to: "team_invites#create"
  put "/join/:code", to: "team_invites#update"
  get "/view_message/:id", to: "messages#view_message", as: :view_message

  get "/dashboard", to: "dashboard#show"
  get "/pricing", to: "pages#pricing"
  get "/terms", to: "pages#terms"
  get "/privacy", to: "pages#privacy"
  get "/security", to: "pages#security"

  namespace :documentation, path: "/docs" do
    get "forwarding_mail", to: "general#forwarding_mail", as: :forwarding_mail
    get "custom_email_address", to: "general#custom_email_address", as: :custom_email_address
    get "contact_forms", to: "general#contact_forms", as: :contact_forms

    get "widget/installation", to: "widget#installation", as: :widget_installation
    get "widget/prefill_data", to: "widget#prefill_data", as: :widget_prefill_data
    get "widget/configuration", to: "widget#configuration", as: :widget_configuration
    root to: "general#index"
  end

  root to: "pages#home"
end
