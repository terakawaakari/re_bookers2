class Book < ApplicationRecord

  validates :title, presence: true
  validates :body,  presence: true, length: { maximum: 200 }

  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.tags.delete Tag.find_by(tag_name: old)
    end

    new_tags.each do |new|
      new_book_tag = Tag.find_or_create_by(tag_name: new)
      self.tags << new_book_tag
    end
  end

  def self.search(search,word)
    if search == "forward_match"
      @books = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @books = Book.where("title LIKE?","%#{word}")
    elsif search == "perfect_match"
      @books = Book.where("#{word}")
    elsif search == "partial_match"
      @books = Book.where("title LIKE?","%#{word}%")
    else
      @books = Book.all
    end
  end
end
