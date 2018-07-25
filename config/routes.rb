=begin
Routes are available via devise_token_auth for user registration and authentication:

                   Prefix Verb     URI Pattern                                                                              Controller#Action

         new_user_session GET      /auth/sign_in(.:format)                                                                  devise_token_auth/sessions#new
             user_session POST     /auth/sign_in(.:format)                                                                  devise_token_auth/sessions#create
     destroy_user_session DELETE   /auth/sign_out(.:format)                                                                 devise_token_auth/sessions#destroy
        new_user_password GET      /auth/password/new(.:format)                                                             devise_token_auth/passwords#new
       edit_user_password GET      /auth/password/edit(.:format)                                                            devise_token_auth/passwords#edit
            user_password PATCH    /auth/password(.:format)                                                                 devise_token_auth/passwords#update
                          PUT      /auth/password(.:format)                                                                 devise_token_auth/passwords#update
                          POST     /auth/password(.:format)                                                                 devise_token_auth/passwords#create
 cancel_user_registration GET      /auth/cancel(.:format)                                                                   devise_token_auth/registrations#cancel
    new_user_registration GET      /auth/sign_up(.:format)                                                                  devise_token_auth/registrations#new
   edit_user_registration GET      /auth/edit(.:format)                                                                     devise_token_auth/registrations#edit
        user_registration PATCH    /auth(.:format)                                                                          devise_token_auth/registrations#update
                          PUT      /auth(.:format)                                                                          devise_token_auth/registrations#update
                          DELETE   /auth(.:format)                                                                          devise_token_auth/registrations#destroy
                          POST     /auth(.:format)                                                                          devise_token_auth/registrations#create
      auth_validate_token GET      /auth/validate_token(.:format)                                                           devise_token_auth/token_validations#validate_token
             auth_failure GET      /auth/failure(.:format)                                                                  devise_token_auth/omniauth_callbacks#omniauth_failure
                          GET      /auth/:provider/callback(.:format)                                                       devise_token_auth/omniauth_callbacks#omniauth_success
                          GET|POST /omniauth/:provider/callback(.:format)                                                   devise_token_auth/omniauth_callbacks#redirect_callbacks
         omniauth_failure GET|POST /omniauth/failure(.:format)                                                              devise_token_auth/omniauth_callbacks#omniauth_failure
=end

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  scope module: 'api' do
    namespace :v1 do
      resources :users, only: [:index, :show]
      resources :products
      resources :purchases, except: [:update, :destroy]
    end
  end
end
