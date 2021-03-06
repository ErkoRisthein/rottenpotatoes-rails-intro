class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    puts "session before: ", session[:sort], session[:ratings]
    if session[:sort].present? && params[:sort].nil? || session[:ratings].present? && params[:ratings].nil?
      flash.keep
      puts "redirecting", session
      redirect_to movies_path(sort: session[:sort], ratings: session[:ratings]) and return
    end
   
    session[:sort] = params[:sort]
    session[:ratings] = params[:ratings]
    
    puts "session after: ", session[:sort], session[:ratings]
    
    @all_ratings = Movie.all_ratings
    
    sort = params[:sort]
    ratings = params[:ratings]
    @checked_ratings = (ratings.present? ? ratings.keys : @all_ratings)
    
    @movies = Movie.where(:rating => @checked_ratings)
    
    if sort == 'title'
      @movies = @movies.order(:title)
    elsif sort == 'release_date'
      @movies = @movies.order(:release_date)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
