Rails.application.routes.draw do
  root to: 'urls#show'
  get ':id', to: 'urls#show'

  scope '/api' do
    post '/encode', to: 'urls#encode'
    get '/decode', to: 'urls#decode'
  end
end
