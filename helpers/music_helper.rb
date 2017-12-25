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
    if song.destroy!
      flash[:notice] = "Song deleted"
      return redirect "/auth/profile/#{session[:user]}"
    else
      flash[:error] = "Error!"
      return redirect "/auth/profile/#{session[:user]}"
    end
  end

  def create_song
    unless params[:file] && (tmpfile = params[:file][:tempfile]) && (filename = params[:file][:filename])
       flash[:notice] = "No file selected"
       return redirect '/music/create/song'
    end

    @song = Song.new(:title => params[:title],
                     :description => params[:description],
                     :genre => params[:genre],
                     :type => params[:type],
                     :license => params[:license],
                     :user_id => session[:user])
    @song.save!
    
    filename = upload_file(@song.id, settings.music_folder, filename, tmpfile)
    @song.update(:url_song => "/" + "tracks/" + filename)

    if @song.saved?
      flash[:notice] = "Successfully created..."
      redirect "/music/song/#{@song.id}"
    else
      flash[:notice] = "Wow your have a error, try again."
      redirect '/music/create/song'
    end

  end

  def edit_song_ajax(mode, id)
    if mode == "image" then
      if !params[:file] || FastImage.type(params[:file][:tempfile]).nil? == true
        halt 200,  {:error => "Format invalid"}.to_json
      else
        @song = Song.get(id)
        filename = upload_file(@song.id, settings.song_image_folder, params[:file][:filename], params[:file][:tempfile])
        @song.update(:song_img_url => "songs/" + filename)
        halt 200,  {:song_image => @song.song_img_url}.to_json
      end
    elsif mode == "all" then
        @song = Song.get(id)
        @song.update(:title => params[:title],
                     :description => params[:description],
                     :genre => params[:genre],
                     :type => params[:type],
                     :license => params[:license])
        
        halt 200, {:song_id => @song.id.to_s}.to_json
    else
        halt 200,  {:error => "Request error"}.to_json
    end
  end

  def add_replay_ajax
    content_type 'application/json', :charset => 'utf-8' if request.xhr?    
    @song = Song.get(params[:id])
    old_replay = @song.replay
    @song.update(:replay => @song.replay + 1)
    if @song.replay > old_replay
      halt 200,  {:replay => @song.replay}.to_json
    else
      halt 200,  {:error => "Wow, a ocurrido un error"}.to_json
    end
  end

  def social_link(class_model)
    if class_model.class == Song then
      @message = SocialUrl::Message.new({
        text: class_model.title + " | " + class_model.description,
        url: "http://localhost:8000/music/song/#{class_model.id}",
        hashtags: %w(#{class_model.genre})
      })
    elsif class_model.class == Album then
      first_tag = class_model.album_tags.get(1)
      @message = SocialUrl::Message.new({
        text: class_model.name + " | " + class_model.description,
        url: "http://localhost:8000/music/album/#{class_model.id}",
        hashtags: %w(#{first_tag})
      })
    end
    return @message
  end

  def create_album
    if params[:file] and FastImage.type(params[:file][:tempfile]).nil? == true then
      flash[:error] = "Upload any image..."
      redirect to("/create/album")
    elsif params[:songs_id].to_s.empty? || params[:tags].to_s.empty? ||
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

    arr_id_songs.each { | id |
      @song = Song.get(id)
      @album.songs << @song
      @album.save
    }
    
    if params[:file]
      filename = upload_file(@album.id, settings.album_image_folder, params[:file][:filename], params[:file][:tempfile])
      @album.update(:album_img_url => "albums/" + filename)
    end

    flash[:notice] = "New album created!"
    return redirect "/auth/profile/#{session[:user]}#album"
  end

  def find_album
    Album.get(params[:id])
  end

  def delete_album
    album = Album.get(params[:id])
    if album.album_tags.destroy! && album.destroy!
      flash[:notice] = "Album deleted"
      return redirect "/auth/profile/#{session[:user]}"
    else
      flash[:error] = "Error!"
      return redirect "/auth/profile/#{session[:user]}"
    end
  end
  
  def edit_album_ajax(mode, id)
    if mode == "image" then
      if !params[:file] || FastImage.type(params[:file][:tempfile]).nil? == true
        halt 200,  { :error => "Format invalid"}.to_json
      else
        @album = Album.get(id)
        filename = upload_file(@album.id, settings.album_image_folder, params[:file][:filename], params[:file][:tempfile])
        @album.update(:album_img_url => "albums/" + filename)
        halt 200,  { :album_image => @album.album_img_url}.to_json
      end
    elsif mode == "all" then
      @album = Album.get(id)

      arr_tags = params[:tags].to_s.split(",")
      arr_id_songs = params[:songs_id].to_s.split(",")
      arr_delete_id_songs = params[:songs_id_delete].to_s.split(",") # NEW CREAR BUCLE PARA ELIMINAR AlbumSong

      @album.update(:name => params[:name],
                    :description => params[:description],
                    :date => params[:date])

      @album.album_tags.destroy
      
      arr_tags.each {  | tag | @album.album_tags.create(:name => tag) }

      arr_delete_id_songs.each {  | id_song |
        # Delete AlbumSong if this already exists
        if relation_album_song = AlbumSong.first(:album_id => @album.id, :song_id => id_song )
          relation_album_song.destroy
        end

      }

      arr_id_songs.each {  | id_song |

        # Prevent repeat relationships in AlbumSong if this already exists
        if relation_album_song = AlbumSong.first(:album_id => @album.id, :song_id => id_song )
          relation_album_song.destroy
        end
        
        @song = Song.get(id_song)
        @album.songs << @song
        @album.save

      }
        halt 200,  {:album_id => @album.id}.to_json
    else
        halt 200,  {:error => "Request error"}.to_json
    end
  end

  def create_comment(model, id, text_body)
    content_type 'application/json', :charset => 'utf-8' if request.xhr?    
    
    [Song, Album].each { | model_class |
        if model_class.name == model.capitalize
            @model = model_class
            break
        end
    }
    
    comment_model = 'Comment' + @model.name
    foreign_key_symbol = (@model.name.downcase + "_id").to_sym
    
    @comment_model = Object.const_get(comment_model)
    comment_create = @comment_model.create(:user_id => session[:user],
                                           foreign_key_symbol => id,
                                           :text => text_body)
    # name user, fecha comentario, foto del usuario, y texto comentario
    if comment_create.saved? then halt 200, {:success => text_body.capitalize}.to_json end

    halt 200, {:error => "error"}.to_json
  end

  def search_comment_for_song(id_song)
    query = repository(:default).adapter.select("
      SELECT DISTINCT
          users.id,
          users.username,
          user_media.profile_img_url,
          comment_songs.text      
      FROM
          users      
      INNER JOIN
          user_media               
              ON users.id = user_media.user_id
      INNER JOIN
          comment_songs 
              ON users.id = comment_songs.user_id
      INNER JOIN
          songs
              ON comment_songs.song_id = #{id_song};"
      ).map{ |struct| { :user_id => struct.id,
                        :username => struct.username,
                        :photo => struct.profile_img_url,
                        :text => struct.text}
        }
    halt 200, { :query => query }.to_json
  end

  def search_comment_for_album(id_album)
    query = repository(:default).adapter.select("
      SELECT DISTINCT
          users.id,
          users.username,
          user_media.profile_img_url,
          comment_albums.text      
      FROM
          (((users      
      INNER JOIN
          user_media               
              ON users.id = user_media.user_id) 
      INNER JOIN
          comment_albums 
              ON users.id = comment_albums.user_id)
      INNER JOIN
          albums
              ON comment_albums.album_id = #{id_album})
    ").map{ |struct| { :user_id => struct.id,
                       :username => struct.username,
                       :photo => struct.profile_img_url,
                       :text => struct.text}
        }
    halt 200, { :query => query }.to_json        
  end

  def like_song
    @song = Song.get(params[:id])
    if !@song.nil?
      if !@song.user_like_songs.first(:user_id => session[:user]).nil?
        @song.user_like_songs.first(:user_id => session[:user]).destroy
      else
        @song.user_like_songs.create(:user_id => session[:user])
      end
      halt 200, {:like => @song.user_like_songs.count == 0 ? "0": @song.user_like_songs.count }.to_json
    else
      halt 303, {:error => 'Error'}.to_json
    end
  end

end