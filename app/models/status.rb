class Status < ActiveRecord::Base
  attr_accessible :content, :user_id, :document_attributes, :image_attributes, :image_id, :document_id
  belongs_to :user
  belongs_to :document
  belongs_to :image

  accepts_nested_attributes_for :document
  accepts_nested_attributes_for :image

  validates :content, presence: true, length: { minimum: 2 }
  validates :user_id, presence: true
end
