module BeforeHelpers
  def before_create_admin(username, email, password, secret="secret")
      user = {:username => username,
              :email => email,
              :password => password,
              :recover_password => secret,
              :role => "admin"}
      @user = User.create(user)
      @user.user_media = UserMedia.create
      @user.user_information = UserInformation.create
      @user.save
      @user.user_media.save
      @user.user_information.save
  end

  def before_create_user(username, email, password, secret="secret")
      user = {:username => username,
              :email => email,
              :password => password,
              :recover_password => secret}
      @user = User.create(user)
      @user.user_media = UserMedia.create
      @user.user_information = UserInformation.create
      @user.save
      @user.user_media.save
      @user.user_information.save
  end

  def before_create_users(n)
    n.times do | i |
      user = {:username => Forgery(:internet).user_name,
              :email => Forgery(:internet).email_address,
              :password => Forgery(:basic).password,
              :recover_password => Forgery(:lorem_ipsum).words(i)}
      @user = User.create(user)
      @user.user_media = UserMedia.create
      @user.user_information = UserInformation.create
      @user.save
      @user.user_media.save
      @user.user_information.save
    end
  end

  def before_create_songs(n)
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
end
