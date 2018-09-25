Rails.application.routes.draw do
  get 'tree/:name', to: 'trees#show'
end
