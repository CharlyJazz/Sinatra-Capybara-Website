module AuthHelpers
  def create_user
    @user = User.create(params[:user])
    @user.user_media = UserMedia.create
    @user.user_information = UserInformation.create
    @user.save
    @user.user_media.save
    @user.user_information.save
    flash[:notice] = "User successfully signed!"
    redirect '/auth'
  end

  def login_user
    @user = User.first(:email => params[:email])
    if @user.class != User
      flash[:warning] = "The email no are correct"
      redirect '/auth'
    end
    if @user.password == params[:password]
      session[:user] = @user.id
      flash[:notice] = "User successfully logged"
      redirect "auth/profile/#{session[:user]}"
    else
      flash[:warning] = "The email or password no are correct"
      redirect '/auth'
    end
  end

  def update_password
    if params[:recover_password].to_s.empty? or
       params[:password_old].to_s.empty? or
       params[:password_new].to_s.empty?
      flash[:warning] = "You send a empty field..."
      return redirect 'auth/change_password'
    end
    @user = User.first(:recover_password => params[:recover_password])
    if @user.class != User or @user.password != params[:password_old]
      flash[:warning] = "Yours dates not are corrects"
      redirect 'auth/change_password'
    else
      @user.update(:password => params[:password_new])
      flash[:notice] = "Your secret is correct, your password changed"
      redirect 'auth/change_password'
    end
  end

  def setting_media
    unless (params[:image_profile] &&
            (tmpfile_profile = params[:image_profile][:tempfile]) &&
            (name_profile = params[:image_profile][:filename])) &&
          (params[:image_banner] &&
            (tmpfile_banner = params[:image_banner][:tempfile]) &&
            (name_banner = params[:image_banner][:filename]))
        flash[:warning] = "No files selected"
        return redirect '/auth/setting'
    end
    @user = User.get(session[:user])
    # Elimino todo lo que esta despues del primer espacio y él,
    # y concateno su extension.
    ext = (/\.[^.]*$/.match(name_profile.to_s)).to_s
    name_profile = "#{@user.id}" + "_" + name_profile.gsub(/\s.+/, '') + ext
    upload_file(settings.profiles_folder, name_profile,  tmpfile_profile)
    @user.user_media.update(:profile_img_url => "profiles/" + name_profile)

    ext = (/\.[^.]*$/.match(name_banner.to_s)).to_s
    name_banner = "#{@user.id}" + "_" + name_banner.gsub(/\s.+/, '') + ext
    upload_file(settings.banners_folder, name_banner,  tmpfile_banner)
    @user.user_media.update(:banner_img_url => "banners/" + name_banner)

    flash[:notice] = "Your media was updated successfully"
    redirect "auth/profile/#{session[:user]}"
  end

  def setting_personal
  end

  def setting_social
  end
end
