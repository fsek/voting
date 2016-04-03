Fsek::Application.routes.draw do
  constraints(host: /^www\./i) do
    get '(*any)' => redirect { |_params, request|
      URI.parse(request.url).tap { |uri| uri.host.sub!(/^www\./i, '') }.to_s
    }, via: [:get, :post]
  end

  get :cookies_information, controller: :static_pages, as: :cookies, path: :cookies
  get :about, controller: :static_pages, path: :om
  get :terms, controller: :static_pages, path: :villkor

  # User-related routes
  devise_for :users, skip: [:sessions, :registrations], controllers: {registrations: "registrations"}
  devise_scope :user do
    get 'avbryt_reg' => 'registrations#cancel', as: :cancel_user_registration
    post 'anvandare/skapa' => 'registrations#create', as: :user_registration
    get 'anvandare/registrera' => 'registrations#new', as: :new_user_registration
    # delete 'anvandare/ta_bort/:id' => 'users#destroy', :as => :admin_destroy_user

    #sessions
    get 'logga_in' => 'devise/sessions#new', as: :new_user_session
    post 'logga_in' => 'devise/sessions#create', as: :user_session
    delete 'logga_ut' => 'devise/sessions#destroy', as: :destroy_user_session
  end

  # Scope to change urls to swedish
  scope path_names: {new: 'ny', edit: 'redigera'} do
    namespace :admin do
      resources :users, path: :anvandare, only: [:index, :edit, :update]
    end

    resource :user, path: :anvandare, as: :own_user, only: [:update] do
      get '', action: :edit, as: :edit
      patch :password, path: :losenord, action: :update_password
      patch :account, path: :konto, action: :update_account
    end

    resources :users, path: :anvandare, only: [:show]

    resources :votes, path: :voteringar, only: :index do
      resources :vote_posts, only: [:new, :create]
    end

    resources :agendas, path: :dagordning, only: :show

    namespace :admin do
      resources :votes, path: :voteringar, controller: :votes do
        patch :close, on: :member
        patch :open, on: :member
        patch :reset, on: :member
        post :refresh, on: :collection
        post :refresh_count, on: :member
      end

      resources :vote_users, path: :motesanvandare, controller: :vote_users, only: [:show, :index] do
        patch :present, on: :member
        patch :not_present, on: :member
        patch :new_votecode, on: :member
        patch :all_not_present, on: :collection
        get :attendance_list, on: :collection
        post :search, on: :collection
      end
    end

    namespace :admin do
      resources :agendas, path: :dagordning, controller: :agendas, except: [:show] do
        patch :set_current, on: :member
        patch :set_closed, on: :member
      end
    end

    namespace :admin do
      resources :adjustments, path: :justering, controller: :adjustments, except: [:show] do
        post :update_row_order, on: :collection
      end
    end

    namespace :admin do
      resources :menus, path: :meny, except: :show
      resources :notices, path: :notiser, except: :show
    end

    namespace :admin do
      resources :contacts, path: :kontakt, except: :show
    end

    resources :contacts, path: :kontakt, only: [:index, :show] do
      post :mail, on: :member
    end

    namespace :admin do
      resources :news, path: :nyheter, except: [:show]
    end

    resources :news, path: :nyheter, only: [:index, :show]

    resources :documents, path: :dokument, only: [:index, :show]

    namespace :admin do
      resources :documents, path: :dokument, except: :show
    end

    namespace :admin do
      resources :permission_users, path: :rattigheter,
                                   controller: :permission_users,
                                   except: [:show, :update]
    end
  end

  root 'static_pages#index'
end
