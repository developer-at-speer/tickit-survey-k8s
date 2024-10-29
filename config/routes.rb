Rails.application.routes.draw do
  resources :survey_responses
  resources :survey_questions
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
