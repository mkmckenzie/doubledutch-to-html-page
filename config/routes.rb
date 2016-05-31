Rails.application.routes.draw do
  get 'sessions/index'

  get 'sessions/import'
  get 'speakers/import'

  get 'programs/:id/download', to: 'programs#download', as: 'program_download'
  

  resources :programs do 
    resources :speakers
    resources :sessions
  end

  root to: "programs#index"
end
