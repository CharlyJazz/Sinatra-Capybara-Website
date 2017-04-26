module WebsiteHelpers

  def search_comment_song()
    repository(:default).adapter.select("
      SELECT DISTINCT
          users.id as user_id,
          users.username,
          user_media.profile_img_url,
          songs.id as song_id,
          songs.title,
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
              ON comment_songs.song_id = songs.id
      LIMIT 4"
      ).map{ |struct| { :user_id => struct.user_id,
                        :username => struct.username,
                        :photo => struct.profile_img_url,
                        :song_id => struct.song_id,
                        :song_title => struct.title,
                        :text => struct.text}
        }
  end

end