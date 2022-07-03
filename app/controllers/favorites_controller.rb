class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    recipe = Recipe.find(params[:recipe_id])
    @favorite = current_user.favorites.new(recipe_id:recipe.id)
    @favorite.save
    #render 'create'
    #redirect_to request.referer
  end

  def destroy
    recipe = Recipe.find(params[:recipe_id])
    @favorite = current_user.favorites.find_by(recipe_id:recipe.id)
    @favorite.destroy
    #render 'destroy'
    #redirect_to request.referer
  end
end
