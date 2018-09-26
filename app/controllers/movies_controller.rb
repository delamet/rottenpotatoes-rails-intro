class MoviesController < ApplicationController
  

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    puts "show called"
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    puts params
    @all_ratings = Movie.getRatings
    @ratingHash = Hash.new
    for rating in @all_ratings 
      @ratingHash[rating] = true
    end
    @movies = Movie.all
    @sort = params[:format]
    @ratingStatus = params[:ratings]
    refresh = params[:commit]
    if refresh == "Refresh"
      keys = @ratingStatus.keys
      @movies = Movie.where(rating: keys)
      for rating in @all_ratings 
         @ratingHash[rating] = false
      end
      for key in keys
        @ratingHash[key] = true
      end
    end
    if @sort == "0"
      @movies = @movies.order(:title)
    elsif @sort == "1"
      @movies = @movies.order(:release_date)
    end
  end
  
  def create
    puts "create called"
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    puts "edit called"
    @movie = Movie.find params[:id]
  end

  def update
    puts "update called"
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    puts "destroy called"
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
