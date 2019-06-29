class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
  	@books = Book.all
    @book = Book.find_by(params[:book_id])
    @user = @book.user
    if params[:tag]
      @books = Book.tagged_with(params[:tag])
    else
      @books = Book.all
    end
  end

  def search
    @books = Book.where("person_id = ?", params[:person_id])
    render 'index'
  end

  def new
    @book_new = Book.new
  end

  def create
  	@book_new = Book.new(book_params)
    @book_new.user_id = current_user.id
  	if  @book_new.save
        flash[:notice] = "質問を作成しました"
  	    redirect_to books_path
    else
        @books = Book.all
        render "index"
    end
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  private
  def book_params
  	params.require(:book).permit(:body, :person_id, :tag_list)
  end

end




