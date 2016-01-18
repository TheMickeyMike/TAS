class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :profile_name, :full_name, :id
  has_many :statuses
  has_many :images

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

  def to_param
    profile_name
  end

  has_many :user_friendships
  has_many :friends, -> { where(user_friendships: {state: 'accepted'}) },
           through: :user_friendships

  has_many :pending_user_friendships, -> { where(user_friendships: {state: 'pending'}) },
           class_name: 'UserFriendship',
           foreign_key: :user_id
  has_many :pending_friends, through: :pending_user_friendships, source: :friend

  def gravatar_url
    stripped_email = email.strip
    downcased_email = stripped_email.downcase
    hash = Digest::MD5.hexdigest(downcased_email)

    "http://gravatar.com/avatar/#{hash}"
  end
end
