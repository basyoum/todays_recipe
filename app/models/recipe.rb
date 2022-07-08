class Recipe < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :recipe_comments, dependent: :destroy
  has_many :recipe_tags, dependent: :destroy
  has_many :tags, through: :recipe_tags

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
  
  #投稿にタグをつける(更新機能)
  def save_tags(saverecipe_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - saverecipe_tags
    new_tags = saverecipe_tags - current_tags
    #Destroy old taggings:
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name:old_name)
    end
    #Create new taggings:
    new_tags.each do |new_name|
      recipe_tag = Tag.find_or_create_by(name:new_name)
      #配列に保存
      self.tags << recipe_tag
    end
  end
  
end
