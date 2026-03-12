Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Public pages
  root "home#index"
  get "philosophy", to: "pages#philosophy", as: :philosophy
  get "about", to: "pages#about", as: :about
  get "contact", to: "contacts#new", as: :contact
  get "join", to: "pages#join", as: :join

  # Seminars
  resources :seminars, only: [:index, :show], param: :slug
  get "seminar-category/:slug", to: "seminars#category", as: :seminar_category_page

  # Activity Reports
  resources :activity_reports, only: [:index, :show], param: :slug, path: "activity-reports"

  # Seminar calendar API (JSON for calendar JS)
  get "api/seminar_events", to: "seminars#calendar_events", as: :api_seminar_events

  # Contact form
  post "contact", to: "contacts#create"
  # Join form
  post "join", to: "pages#create_join"

  # Admin namespace
  namespace :admin do
    resources :seminars
    resources :categories
    resources :activity_reports
    root to: "seminars#index"
  end
end
