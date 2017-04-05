module MusicHelpers
  def find_songs
    @songs = Song.all
  end

  def find_song
    Song.get(params[:id])
  end

  def find_song_by_user(id)
    @songs = Song.all(:user_id => id)  
  end

  def delete_song
    song = Song.get(params[:id])
    if song.destroy
      flash[:notice] = "Song deleted"
      return redirect "/auth/profile/#{session[:user]}"
    else
      flash[:error] = "Error!"
      return redirect "/auth/profile/#{session[:user]}"
    end
  end

  def create_music
    unless params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
       flash[:notice] = "No file selected"
       return redirect '/music/create/song'
    end

    @song = Song.create(:title => params[:title],
                        :description => params[:description],
                        :genre => params[:genre],
                        :type => params[:type],
                        :license => params[:license],
                        :user_id => session[:user]
                        )

    filename =  "#{@song.id}" + "_" + params[:file][:filename]
    @song.update(:url_song => "/" + "tracks/" + filename)
    upload_file(settings.music_folder, filename, tmpfile)
    if @song.saved?
      flash[:notice] = "Successfully created..."
      redirect "/music/play/#{@song.id}"
    else
      flash[:notice] = "Wow your have a error, try again."
      redirect '/music/create/song'
    end

  end

  def song_social_link(song)
    @message = SocialUrl::Message.new({
      text: song.title + " | " + song.description,
      url: "http://localhost:8000/music/play/#{song.id}",
      hashtags: %w(#{@song.genre})
    })
    return @message
  end

  def create_album
    if !params[:file] || FastImage.type(params[:file][:tempfile]).nil? == true ||
        params[:songs_id].to_s.empty? || params[:tags].to_s.empty? ||
        params[:description].to_s.empty? || params[:date].to_s.empty? ||
        params[:name].to_s.empty?

      flash[:error] = "Any field was are empty"
      redirect to("/create/album")
    end
  
    arr_tags = params[:tags].to_s.split(",")
    arr_id_songs = params[:songs_id].to_s.split(",")

    @album = Album.create(:name => params[:name],
                          :description => params[:description],
                          :date => params[:date],
                          :user_id => session[:user])

    arr_tags.each { | tag | @album.album_tags.create(:name => tag) }

    arr_id_songs.each do | id |
      @song = Song.get(id)
      @album.songs << @song
      @album.save
    end

    flash[:notice] = "New album created!"
    return redirect "/auth/profile/#{session[:user]}"

  end
end
