class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @books = Book.order(favorites_count: "DESC").page(params[:page])
    @book = Book.find_by(params[:book_id])
    @favorites = Favorite.where(user_id: session[:user_id], book_id: @book.id)
    if params[:tag]
      @books = Book.tagged_with(params[:tag]).page(params[:page])
    else
      @books = Book.order(favorites_count: "DESC").page(params[:page])
    end
  end

  def top
    @books = Book.order(created_at: "DESC").page(params[:page])
    @book = Book.find_by(params[:book_id])
    @favorites = Favorite.where(user_id: session[:user_id], book_id: @book.id)
    if params[:tag]
      @books = Book.tagged_with(params[:tag]).page(params[:page])
    else
      @books = Book.order(created_at: "DESC").page(params[:page])
    end
  end

  def search
      @books = Book.where("person_name = ?", params[:person_name]).page(params[:page])
      @bookd = Book.find_by("person_name = ?", params[:person_name])
      render :index, locals: { bookd: @bookd }
  end

  def books
    person_id_first = Person_idName.find(1)
    @person_id = params[person_id] || book_first
    @books = Book.where("person_id = ?", params[:person_id]).page(params[:page])
  end

  def book_search
      person_id.name.all.map{|person_id_name| [person_id_name.name, person_id_name.id]}
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
        @book_new = Book.new(book_params)
        render "new"
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
  	params.require(:book).permit(:body, :person_name, :tag_list)
  end

  def search_params
    params.require(:q).permit(:person_name)
  end

end




