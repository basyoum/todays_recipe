class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :recipes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :recipe_comments, dependent: :destroy
  
  validates :name, length: { minimum: 1, maximum: 30 }, uniqueness: true
  validates :introduction, length: { maximum: 200 }
  
  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where(' name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where(' name LIKE ? ', '%' + content)
    else
      User.where(' name LIKE ?', '%' + content + '%')
    end
  end
  
end
