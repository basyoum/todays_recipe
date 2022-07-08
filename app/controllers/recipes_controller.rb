class RecipesController < ApplicationController
  def index
    @tag_list = Tag.all
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
    @recipe_comment = RecipeComment.new
    @recipe_tags = @recipe.tags
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id
    #投稿にタグを追加
    tag_list = params[:recipe][:tag_name].split(',')
    if @recipe.save
      @recipe.save_tags(tag_list)
      flash[:notice] = '新規レシピの投稿が完了しました。'
      redirect_to recipes_path
    else
      flash[:error] = '新規レシピの投稿に失敗しました。'
      render :new
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update(recipe_params)
      flash[:notice] = 'レシピを編集しました。'
      redirect_to recipe_path
    else
      flash[:error] = 'レシピの編集に失敗しました。'
      render :edit
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    redirect_to recipes_path
  end
  
  private
  
  def recipe_params
    params.require(:recipe).permit(:recipe_image, :title, :body)
  end
end
