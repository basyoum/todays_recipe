class Admin::RecipeCommentsController < ApplicationController
  before_action :authenticate_admin!

  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_comment = RecipeComment.find(params[:id])
    @recipe_comment.destroy
    flash[:notice] = 'コメントを削除しました'
    redirect_to admin_recipe_path(@recipe)
  end
end
