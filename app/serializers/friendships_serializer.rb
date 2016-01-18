class FriendshipsSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :friend_id, :created_at, :updated_at, :state

  has_one :user, serializer: UserShortSerializer
  has_one :friend, serializer: UserShortSerializer
end
