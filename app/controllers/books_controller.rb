class BooksController < ApplicationController

  def index
    @books = Book.page(params[:page]).reverse_order
    @book = Book.new
    @user_id = current_user
    @tag_list = Tag.all
  end

  def create
    @book = Book.new(book_params)
    tag_list = params[:book][:tag_name].split(nil)
    @book.user_id = current_user.id
    if @book.save
      @book.save_tag(tag_list)
      redirect_to book_path(@book), notice:'You have created book successfully.'
    else
      @books = Book.page(params[:page]).reverse_order
      @user_id = current_user
      render :index
    end
  end

  def show
    @book_find = Book.find(params[:id])
    @user = current_user
    @book = Book.new
    @post_comment = PostComment.new
    @book_tags = @book_find.tags
  end

  def edit
    @book = Book.find(params[:id])
    @user_id = current_user
    unless @book.user == current_user
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id), notice:"You have updated book successfully."
    else
      @user_id = current_user
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def search
    if params[:title].present?
      @books = Book.where('title LIKE ?', "%#{params[:title]}%")
    else
      @books = Book.none
    end
  end

  private
  def book_params
    params.require(:book).permit(:title,:body)
  end

end
