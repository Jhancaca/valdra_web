Rails.application.routes.draw do
  # Admin authentication is intentionally registered before the Spree engine.
  # This makes /admin/login resolve before the Admin dashboard's catch-all
  # routes, while the admin UI itself remains mounted under /admin.
  devise_for(
    Spree.admin_user_class.model_name.singular_route_key,
    class_name: Spree.admin_user_class.to_s,
    controllers: {
      sessions: "spree/admin/user_sessions",
      passwords: "spree/admin/user_passwords"
    },
    skip: :registrations,
    path: "admin",
    path_names: { sign_in: "login", sign_out: "logout" }
  )
  post "/api/v3/store/customer_registrations", to: "spree/api/v3/store/customer_registrations#create"
  # Spree remains a headless commerce backend. Its Store API, Admin API and
  # native admin UI are provided by the engine; the customer-facing UI lives
  # exclusively in the separate Next.js storefront.
  mount Spree::Core::Engine, at: "/"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

end
