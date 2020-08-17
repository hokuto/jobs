Rails.application.routes.draw do
  root 'jobs#index'
  resources :jobs, only: :index do
    get 'exec_batch', on: :collection
  end
end
