class UsersController < ApplicationController

  def index
    @users = User.page(params[:page]).reverse_order
    @user_id = current_user
    @book = Book.new
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books.page(params[:page]).reverse_order
    @user_id = current_user
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
    @user_id = current_user

    if @user != current_user
      redirect_to user_path(current_user), alert: "#{@user.name}の情報は変更できません"
    elsif current_user.email == 'guest@example.com'
      redirect_to user_path(current_user), alert: 'ゲストユーザー情報は変更できません'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
    redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      @user_id = current_user
      render :edit
    end
  end

  def show_following
    @user  = User.find(params[:id])
    @users = User.page(params[:page]).reverse_order
  end

  def show_followers
    @user  = User.find(params[:id])
    @users = User.page(params[:page]).reverse_order
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def book_params
    params.require(:book).permit(:title,:body)
  end

end
