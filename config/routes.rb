require 'sidekiq/web'

Rails.application.routes.draw do
  root 'hello#index'

  get '/hello/index'
  get '/goodbye', to: 'application#goodbye'
  get '/upsert', to: 'hello#upsert'
  get '/debug', to: 'hello#debug'
  get '/insert', to: 'hello#insert'

  resources :ajax

  mount Sidekiq::Web => '/sidekiq'
end
