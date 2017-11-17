# frozen_string_literal: true

Rails.application.routes.draw do
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
    resources :contacts, path: :kontakt, only: [:index] do
      post :mail, on: :collection
    end
    resources :documents, path: :dokument, only: %i[index show]
    resource :user, path: :anvandare, only: [:update] do
      get '', action: :edit, as: :edit
      patch :password, path: :losenord, action: :update_password
      patch :account, path: :konto, action: :update_account
    end

    resources :agendas, path: :dagordning, only: %i[index show]
    resources :votes, path: :voteringar, only: :index do
      resources :vote_posts, only: %i[new create]
    end

    namespace :admin do
      resources :documents, path: :dokument, except: :show
      resources :news, path: :nyheter, except: [:show]

      resources :adjustments, path: :justering, except: [:show] do
        post :update_row_order, on: :collection
      end

      resources :agendas, path: :dagordning, except: [:show]
      resources :current_agendas, path: 'aktuell-dagordning',
                                  only: %i[update destroy]

      resources :attendances, path: :narvaro, only: %i[index update destroy] do
        delete('', action: :destroy_all, on: :collection)
      end

      resources :users, path: :anvandare, only: %i[index edit update]
      resources :votes, path: :voteringar, controller: :votes do
        resource :reset, only: :create, path: :aterstall
        resource :opening, only: %i[create destroy], path: :oppna
        post :refresh_count, on: :member
      end

      resources :vote_users, path: :motesanvandare, only: %i[show index]

      resources :votecodes, path: :rostkod, only: :update
      resource :search, path: :sok, only: [] do
        post(:card)
        post(:user)
      end
    end
  end

  root 'static_pages#index'
end
