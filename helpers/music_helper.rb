module MusicHelpers
  def find_songs
    @songs = Song.all
  end

  def find_song
    Song.get(params[:id])
  end

  def create_music
    directory = "public/music"

    upload_music(directory)

    @song = Song.create(:title => params[:title],
                        :description => params[:description],
                        :genre => params[:genre],
                        :type => params[:type],
                        :license => params[:license],
                        :user_id => session[:user]
                        )
    @song.update(:url_song => directory + "/#{@song.id}" + "_" + params[:file][:filename])

    if @song.saved?
      flash[:notice] = "Successfully created..."
      # => Cambiar redirect a ruta de la cancion
      redirect '/music/create'
    else
      flash[:notice] = "Wow your have a error, try again."
      redirect '/music/create'
    end

  end

  def upload_music(directory)
    unless params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
       flash[:notice] = "No file selected"
       redirect '/music/upload'
    end
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(tmpfile.read) }
  end

end
