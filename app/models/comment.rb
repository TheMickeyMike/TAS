class Comment < ActiveRecord::Base

  attr_accessible :comment, :post_id, :author_id
  belongs_to :user
  belongs_to :statuses

  validates :comment, presence: true,
            length: {minimum: 2}


  #validates :post_id, presence: true

end
