class Admin::UsersController < ApplicationController
before_action :authenticate_admin!
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "会員情報の編集が完了しました。"
      redirect_to admin_user_path(@user)
    else
      flash[:notice] = "会員情報の編集に失敗しました。"
      render :edit
    end
  end
  
  def recipe
    @user = User.find(params[:id])
    @recipes = @user.recipes.all
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :introduction, :is_deleted)
  end
end
