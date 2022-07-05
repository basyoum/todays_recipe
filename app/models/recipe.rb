class Recipe < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :recipe_comments, dependent: :destroy
  has_one_attached :recipe_image
  
  validates :title, presence:true
  validates :body, presence:true
  
  def get_recipe_image(width,height)
    unless recipe_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      recipe_image.attach(io:File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
      recipe_image.variant(resize_to_limit: [width,height]).processed
  end
  
  #どの投稿にいいねしているかを判断
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  def self.search_for(content, method)
    if method == 'perfect'
      Recipe.where(title: content)
    elsif method == 'forward'
      Recipe.where(' title LIKE ?', content + '%')
    elsif method == 'backward'
      Recipe.where(' title LIKE ? ', '%' + content)
    else
      Recipe.where(' title LIKE ?', '%' + content + '%')
    end
  end
  
end
