class ImageSerializer < ActiveModel::Serializer
  attributes :img, :image_path, :user_id, :created_at, :updated_at
end