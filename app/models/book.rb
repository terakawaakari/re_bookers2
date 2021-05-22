class Book < ApplicationRecord

  validates :title, presence: true
  validates :body,  presence: true, length: { maximum: 200 }

  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :tag_maps, dependeny: :destroy
  has_many :tags, through: :tag_maps

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

end
