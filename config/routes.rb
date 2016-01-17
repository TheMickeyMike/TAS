TAS::Application.routes.draw do
  use_doorkeeper
  mount Statuses::StatusesController => '/api'
  mount Users::UsersController => '/api'
  mount Friendships::FriendshipsController => '/api'
  mount Comments::CommentsController => '/api'
  mount Files::FilesController => '/api'
  mount Attachments::AttachmentsController => '/api'
  mount Messages::MessagesController => '/'
  resources :user_friendships do
    member do
      put :accept
    end
  end

  resources :statuses
  get 'feed', to: 'statuses#index', as: :feed
  root to: 'statuses#index'
  get '/:id', to: 'profiles#show', as: 'profile'
end
