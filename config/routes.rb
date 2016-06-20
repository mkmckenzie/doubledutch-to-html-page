Rails.application.routes.draw do
  devise_for :users
  get 'sessions/index'

  get 'sessions/import'
  get 'speakers/import'

  get 'programs/:id/download', to: 'programs#download', as: 'program_download'

  get 'programs/:program_id/sessions/:id/download', to: 'sessions#download', as: 'program_session_download'

  get 'programs/:id/text', to: 'programs#text', as: 'program_text'

  get "/pages/welcome", to: "pages#welcome", as: 'pages_welcome'
  get "/pages/howto", to: "pages#howto", as: 'pages_howto'
  

  resources :programs do 
    resources :speakers
    resources :sessions
  end

  root to: 'pages#welcome'
end
