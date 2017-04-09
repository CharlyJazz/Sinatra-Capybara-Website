module BeforeHelpers
  def before_create_user(options={:username=>nil, :email=>nil, :password=>nil, :recover_password=>"secret"})
    if options[:amount] > 1
      options[:amount].times do | i |
        @user = User.create(:username => Forgery(:internet).user_name,
                            :email => Forgery(:internet).email_address,
                            :password => Forgery(:basic).password,
                            :recover_password => Forgery(:lorem_ipsum).words(i))
        @user.user_media = UserMedia.create
        @user.user_information = UserInformation.create
        @user.save
        @user.user_media.save
        @user.user_information.save
      end
    else
        @user = User.create(:username => options[:username],
                            :email => options[:email],
                            :password => options[:password],
                            :recover_password => options[:recover_password])
        @user.user_media = UserMedia.create
        @user.user_information = UserInformation.create
        @user.save
        @user.user_media.save
        @user.user_information.save
    end
  end

  def before_create_song(n)
    n.times do |i|
    @song = Song.create(:title => Forgery(:internet).user_name,
                        :description => Forgery(:lorem_ipsum).words(5),
                        :genre => "rock and roll",
                        :type => "original",
                        :license => "all_right_reserved",
                        :user_id => 1)
    @song.update(:url_song => "/" + "sound_test/maindrum.wav")
    end
  end

  def before_create_social(n)
    n.times do | i |
    @user = User.get(1)
    @user.user_socials.create(:url => "https://webpage.com/" + Forgery(:internet).user_name,
                              :name => Forgery(:internet).user_name)
    end
  end

  def before_create_album(n)
    n.times do |i|
      @album = Album.create(:name => Forgery(:internet).user_name,
                            :description => Forgery(:lorem_ipsum).words(5),
                            :date => Forgery(:date).date,
                            :likes => Forgery(:basic).number,
                            :user_id => 1)
      @album_tag = AlbumTag.create(:name => Forgery(:name).company_name,
                                   :album_id => i + 1)
      @song = Song.get(1)
      @album.songs << @song
      @album.save
    end    
  end

  def before_create_comment_album(n, album_id, user_id)
    n.times do | i |
      CommentAlbum.create(:text => Forgery(:lorem_ipsum).words(5),
                          :likes => Forgery(:basic).number,
                          :album_id => album_id,
                          :user_id => user_id)
    end
  end
  def before_create_comment_song(n, song_id, user_id)
    n.times do | i |
      CommentSong.create(:text => Forgery(:lorem_ipsum).words(5),
                          :likes => Forgery(:basic).number,
                          :song_id => song_id,
                          :user_id => user_id)
    end
  end  
end
