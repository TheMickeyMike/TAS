class CommentsSerializer < ActiveModel::Serializer
  attributes :id, :post_id, :comment, :created_at, :updated_at

  has_one :user, serializer: UserShortSerializer
  has_one :statuses, serializer: StatusesShortSerializer
end
