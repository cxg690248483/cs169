class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #part3  remember
    if(params[:sort] == nil && params[:ratings] == nil)
      if(session[:sort] != nil || session[:ratings] != nil)
        redirect_to movies_path(:sort=>session[:sort], :ratings=>session[:ratings])
      end
    end
    
    #part1  sorting
    @sort = params[:sort]
    if(@sort == 'titleheader')
      @sort = :title
    elsif(@sort == 'dateheader')
      @sort = :release_date
    end
    session[:sort] = @sort

    
    #part2  rating checkbox
    @all_ratings = Movie.all_ratings.keys
    @ratings = params[:ratings]
    if(@ratings != nil)
      ratings = @ratings.keys
      session[:ratings] = @ratings
    #if no current input ratings, but input sort, use last time input ratings
    else
      if(params['commit'] == nil && params['sort'] == nil)
        ratings = Movie.all_ratings.keys
        session[:ratings] = Movie.all_ratings
      else
        ratings = session[:ratings].keys
      end
    #if no current input ratings and input sort, ratings filter = all_ratings
#else
#ratings = Movie.all_ratings
#session[:ratings] = Movie.all_ratings
    end

    if(@sort != nil) 
      @movies = Movie.order(@sort).find_all_by_rating(ratings)
    else
      @movies = Movie.find_all_by_rating(ratings)
    end
    
    #indicate checked boxes
    @checked  = ratings
  
#@movies = Movie.find_all_by_rating(ratings)

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def header_class(header)
    if(params[:sort] == header)
      return 'hilite'
    else
      return nil
    end
  end
  helper_method :header_class

end
