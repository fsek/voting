# frozen_string_literal: true

Rails.application.routes.draw do
  get 'attendance_list/index'

  get :cookies_information, controller: :static_pages,
                            as: :cookies, path: :cookies
  get :about, controller: :static_pages, path: :om
  get :terms, controller: :static_pages, path: :villkor

  devise_for :users, skip: [:sessions]
  devise_scope :user do
    get 'logga-in', to: 'devise/sessions#new', as: :new_user_session
    post 'logga-in', to: 'devise/sessions#create', as: :user_session
    delete 'logga-ut', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  # Scope to change urls to swedish
  scope path_names: { new: 'ny', edit: 'redigera' } do
    namespace :admin do
      resources :users, path: :anvandare, only: %i[index edit update]
    end

    resource :user, path: :anvandare, only: [:update] do
      get '', action: :edit, as: :edit
      patch :password, path: :losenord, action: :update_password
      patch :account, path: :konto, action: :update_account
    end

    resources :votes, path: :voteringar, only: :index do
      resources :vote_posts, only: %i[new create]
    end

    resources :agendas, path: :dagordning, only: %i[index show]

    namespace :admin do
      resources :votes, path: :voteringar, controller: :votes do
        patch :close, on: :member
        patch :open, on: :member
        patch :reset, on: :member
        post :refresh, on: :collection
        post :refresh_count, on: :member
      end

      resources :vote_users, path: :motesanvandare, only: %i[show index] do
        patch :present, on: :member
        patch :not_present, on: :member
        patch :new_votecode, on: :member
        patch :all_not_present, on: :collection
        post :search, on: :collection
      end

      resource :attendance_list, path: :narvarolista, only: :show
    end

    namespace :admin do
      resources :agendas, path: :dagordning, except: [:show] do
        patch :set_current, on: :member
        patch :set_closed, on: :member
      end
    end

    namespace :admin do
      resources :adjustments, path: :justering, except: [:show] do
        post :update_row_order, on: :collection
      end
    end

    resources :contacts, path: :kontakt, only: [:index] do
      post :mail, on: :collection
    end

    namespace :admin do
      resources :news, path: :nyheter, except: [:show]
    end

    resources :documents, path: :dokument, only: %i[index show]

    namespace :admin do
      resources :documents, path: :dokument, except: :show
    end
  end

  root 'static_pages#index'
end
