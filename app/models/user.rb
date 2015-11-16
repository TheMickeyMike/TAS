class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
    
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :profile_name, :full_name, :id
  # attr_accessible :title, :body
<<<<<<< HEAD
  has_many :statuses

  validates :first_name, presence: true

  validates :last_name, presence: true

  validates :profile_name, presence: true,
                           uniqueness: true,
                           format: {
                             with: /[a-zA-Z0-9_-]+/,
                             message: 'Must be formatted correctly.'
                           }

  def full_name
    first_name + " " + last_name
  end
||||||| merged common ancestors
=======


    has_many :statuses
>>>>>>> origin/master
end
