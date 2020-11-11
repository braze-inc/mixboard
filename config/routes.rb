# frozen_string_literal: true

Mixboard::Engine.routes.draw do
  root to: 'dynamic_channels#index'
  get 'dynamic_channels/create', to: 'dynamic_channels#start_create_wizard'
  post 'dynamic_channels/create', to: 'dynamic_channels#create'
  delete 'dynamic_channels/destroy/:id', to: 'dynamic_channels#destroy'
end
