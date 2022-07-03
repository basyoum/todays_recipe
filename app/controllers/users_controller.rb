class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only:[:edit, :update]
  
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
      flash[:notice] = 'ユーザー情報の変更を保存しました。'
      redirect_to user_path(@user)
    else
      flash[:error] = 'ユーザー情報の編集に失敗しました。'
      render :edit
    end
  end
  
  def quit
  end
  
  def out
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :introduction)
  end
  
  def ensure_correct_user
    @user = User.find(params[:id])
    redirect_to(user_path(current_user)) unless @user == current_user
  end
  
end
