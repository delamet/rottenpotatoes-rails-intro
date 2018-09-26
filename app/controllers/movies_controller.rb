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
    @movies = Movie.all
    sort = params[:format]
    ratingStatus = params[:ratings]
    if sort == nil 
      # No sort, use session sort
      @sort = session[:format]
    else
      @sort = sort
      session[:format] = @sort
    end
    if ratingStatus == nil || ratingStatus.length == 0
      # No ratings or ratings in 0, use session ratings
      @ratingStatus = session[:ratings]
    else 
      @ratingStatus = ratingStatus
      session[:ratings] = ratingStatus
    end
    refresh = params[:commit]
    @all_ratings = Movie.getRatings
    @ratingHash = Hash.new
    for rating in @all_ratings 
      # initialy populate ratings hash to all true
      @ratingHash[rating] = true
    end
    if refresh == "Refresh"
      # filter ratings pressed
      keys = @ratingStatus.keys
      @movies = Movie.where(rating: keys)
      for rating in @all_ratings 
        # initialy set ratings hash to false
         @ratingHash[rating] = false
      end
      for key in keys
        # set ratings hash true for selected ratings
        @ratingHash[key] = true
      end
    end
    if @sort == "0"
      # sort by title
      @movies = @movies.order(:title)
    elsif @sort == "1"
      # sort by release date
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
