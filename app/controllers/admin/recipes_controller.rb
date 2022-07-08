class Admin::RecipesController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @recipes = Recipe.all
  end
  
  def show
    @recipe = Recipe.find_by(id: params[:id])
  end
end
