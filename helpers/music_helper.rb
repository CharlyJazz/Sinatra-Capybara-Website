module MusicHelpers
  def find_songs
    @songs = Song.all
  end

  def find_song
    Song.get(params[:id])
  end

  def create_music
    @song = Song.create(:title => params[:title],
                        :description => params[:description],
                        :genre => params[:genre],
                        :type => params[:type],
                        :license => params[:license],
                        :user_id => session[:user]
                        )
    puts params[:title]
    puts params[:description]
    puts params[:genre]
    puts params[:type]
    puts params[:license]
    puts session[:user]
    puts @song.saved?

    if @song.saved?
      flash[:notice] = "Successfully created..."
      # => Cambiar redirect a ruta de la cancion
      redirect '/music/create'
    else
      flash[:notice] = "Wow your have a error, try again."
      redirect '/music/create'
    end

  end

end
