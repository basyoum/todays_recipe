class Tag < ApplicationRecord
  has_many :recipe_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :recipes, through: :recipe_tags

  scope :merge_recipes, -> (tags){ }

  def self.search_recipes_for(content, method)
    if method == "perfect"
      tags = Tag.where("name LIKE?", "#{content}")
    elsif method == "forward"
      tags = Tag.where("name LIKE?", "#{content}%")
    elsif method == "backward"
      tags = Tag.where("name LIKE?", "%#{content}")
    else
      tags = Tag.where("name LIKE?", "%#{content}%")
    end
    return tags.inject(init = []) {|result, tag| result + tag.recipes}
  end
  
end
