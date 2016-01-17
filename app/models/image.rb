class Image < ActiveRecord::Base
  attr_accessible :img, :image_path, :remove_img, :user_id
  belongs_to :user
  has_attached_file :img
  
  attr_accessor :remove_img
  before_save :perform_img_removal
    def perform_img_removal
        if remove_img == '1' && !img.dirty?
          self.img = nil
        end
    end
  end
