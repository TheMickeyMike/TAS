module Friendships
  class FriendshipsController < Grape::API
    version 'v1', using: :path
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers
    use ::WineBouncer::OAuth2

    default_error_status 400

    rescue_from WineBouncer::Errors::OAuthUnauthorizedError do |e|
      error!({error: e.message}, 401)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      error!({error: 'Not Found.'}, 404)
      # error!({ error: e.message }, 404)
    end


    resource :friendships do

      desc 'Return a owner friendships'
      oauth2
      get :index, root: false, each_serializer: FriendshipsSerializer do
        resource_owner.user_friendships.all
      end

      desc 'New friendships'
      oauth2
      params do
        requires :friend_id, type: String, desc: 'User id'
        # TODO Nie wiem czy lepsza opcja by nie było podawanie ID uzytkownika
      end
      post :new do
        @friend = User.where(id: params[:friend_id]).first
        resource_owner.user_friendships.new(friend: @friend)
      end


      desc 'Create friendships (Accept sending req)'
      # {"user_friendship": {"friend_id":"ania"}}
      # TODO Lepiej podać ID uzytkownika?
      oauth2
      params do
        requires :user_friendship, type: Hash do
          requires :friend_id, type: String, desc: 'Friendship ID?'
        end
      end
      post :create do
        @friend = User.where(id: params[:user_friendship][:friend_id]).first
        @user_friendship = UserFriendship.request(resource_owner, @friend)
        if @user_friendship.new_record?
          error!({error: 'unexpected error', detail: 'There was a problem creating that friend request.'}, 500)
        else

        end
      end

      route_param :id do

        desc 'Edit friendships'
        oauth2
        put :edit do
          @user_friendship = resource_owner.user_friendships.find(params[:id])
          @friend = @user_friendship.friend
        end

        desc 'Accept friendships'
        oauth2
        put :accept do
          @user_friendship = resource_owner.user_friendships.find(params[:id])
          if @user_friendship.accept!
            # TODO
          else
            error!({error: 'unexpected error', detail: 'That friendship could not be accepted. She is too young.'}, 500)
          end
        end

        desc 'Delete friendships'
        oauth2
        params do
          requires :id, type: Integer, desc: 'Friendship ID'
        end
        delete do
          resource_owner.user_friendships.find(params[:id]).destroy
        end
      end
    end

  end
end
