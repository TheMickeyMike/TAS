class ImageShortSerializer < ActiveModel::Serializer
  attributes :img, :image_path, :user_id, :created_at, :updated_at

  has_one :user, serializer: UserShortSerializer
  #has_one :statuses, serializer: StatusesShortSerializer
end
