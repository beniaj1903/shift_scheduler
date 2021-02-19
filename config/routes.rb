Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do 
      resources :shifts, only: [:index, :dashboard, :create, :edit, :delete]
      post 'shifts/availabilities' => 'shifts#availabilities'
      post 'shifts/distribute' => 'shifts#distribute'
    end
  end
end
