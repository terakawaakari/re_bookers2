class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { minimum:2, maximum:20 },uniqueness: true
  validates :introduction, length: { maximum:50 }

  #validates :introduction,  presence: true

  attachment :profile_image

  has_many :books, dependent: :destroy

  has_many :book_comments, dependent: :destroy

  has_many :favorites, dependent: :destroy
  # has_many :favorited_books, through: :favorites, source: :book

  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follower

  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :user

  has_many :groups, through: :group_users
  has_many :group_users

  def follow(other_user)
    return if self == other_user
    relationships.find_or_create_by!(follower: other_user)
  end

  def following?(user)
    followings.include?(user)
  end

  def unfollow(relationship_id)
    relationships.find(relationship_id).destroy!
  end

  def self.search(search,word)
    if search == "forward_match"
      @users = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @users = User.where("name LIKE?","%#{word}")
    elsif search == "perfect_match"
      @users = User.where("#{word}")
    elsif search == "partial_match"
      @users = User.where("name LIKE?","%#{word}%")
    else
      @users = User.all
    end
  end
end
