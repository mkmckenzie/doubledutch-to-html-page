Rails.application.routes.draw do
  get 'sessions/index'

  get 'sessions/import'
  get 'speakers/import'

  get 'programs/:id/download', to: 'programs#download', as: 'program_download'

  get 'programs/:program_id/sessions/:id/download', to: 'sessions#download', as: 'program_session_download'
  

  resources :programs do 
    resources :speakers
    resources :sessions
  end

  root to: "programs#index"
end
