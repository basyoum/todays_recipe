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
  
  def self.guest
    find_or_create_by!(name: 'ゲストユーザー' ,email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
    end
  end
  
  def active_for_authentication?
    super && (is_deleted == false)
  end
  
  def is_deleted_color
    is_deleted ? "font-weight-bold text-muted":"font-weight-bold text-success"
  end
  
end
