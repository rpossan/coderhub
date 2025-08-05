Rails.application.routes.draw do
  root "profiles#index"

  resources :profiles do
    member do
      patch :rescan
    end
    collection do
      get :search
    end
  end

  get "/s/:short_code", to: "profiles#show_by_short", as: :short_profile

  get "up" => "rails/health#show", as: :rails_health_check
end
