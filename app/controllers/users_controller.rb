class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only:[:edit, :update, :quit]
  before_action :ensure_guest_user, only: [:edit, :quit]
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @recipes = @user.recipes.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = 'ユーザー情報の変更を保存しました。'
      redirect_to user_path(@user)
    else
      flash[:notice] = 'ユーザー情報の編集に失敗しました。'
      render :edit
    end
  end
  
  def quit
  end
  
  def out
    @user = User.find(params[:id])
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "ありがとうございました。またのご利用を心よりお待ちしております。"
    redirect_to root_path
  end
  
  #いいねの一覧表示
  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:recipe_id)
    @favorite_recipes = Recipe.find(favorites)
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :introduction)
  end
  
  def ensure_correct_user
    @user = User.find(params[:id])
    redirect_to(user_path(current_user)) unless @user == current_user
  end
  
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "ゲストユーザー"
      redirect_to user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end
  
end
