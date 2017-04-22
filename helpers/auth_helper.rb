require 'rack'

module AuthHelpers
  def create_user
    if params[:username].to_s.empty? || params[:email].to_s.empty? ||
       params[:password].to_s.empty? || params[:recover_password].to_s.empty?
       flash[:error] = "Any field are empty!"
       redirect '/auth'
    else       
      @email_use = User.first(:email => params[:email])
      @username_use = User.first(:username => params[:username])
      if !@username_use.nil?
        flash[:warning] = "This username are existing"
        redirect '/auth'
      elsif !@email_use.nil?
        flash[:warning] = "This email are existing"
        redirect '/auth'
      else
        @user = User.create(:username => params[:username],
                            :email => params[:email], 
                            :password => params[:password],
                            :recover_password => params[:recover_password])
        @user.user_media = UserMedia.create
        @user.user_information = UserInformation.create
        @user.save
        @user.user_media.save
        @user.user_information.save
        flash[:notice] = "User successfully signed!"
        redirect '/auth'   
      end
    end
  end

  def login_user
    @user = User.first(:email => params[:email])
    if @user.class != User
      flash[:warning] = "The email or password no are correct"
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
    @user = User.get(session[:user])
    if params[:password_old] == params[:password_new]
      flash[:warning] = "The password are sames"      
      redirect 'auth/change_password'
    elsif @user.class != User or @user.recover_password != params[:recover_password] or @user.password != params[:password_old]
      flash[:warning] = "Yours dates not are corrects"
      redirect 'auth/change_password'
    else
      @user.update(:password => params[:password_new])
      flash[:notice] = "Your secret is correct, your password changed"
      redirect to("/profile/#{session[:user]}")
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
    filename = upload_file(@user.id, settings.profiles_folder, name_profile, tmpfile_profile)
    @user.user_media.update(:profile_img_url => "profiles/" + filename)
    filename = upload_file(@user.id, settings.banners_folder, name_banner, tmpfile_banner)
    @user.user_media.update(:banner_img_url => "banners/" + filename)

    flash[:notice] = "Your media was updated successfully"
    redirect to("/profile/#{session[:user]}")
  end

  def setting_personal
    if params[:display_name].to_s.empty? || params[:first_name].to_s.empty? ||
       params[:last_name].to_s.empty? || params[:country].to_s.empty? ||
       params[:city].to_s.empty? || params[:bio].to_s.empty?

       flash[:error] = "Any field was are empty"
       redirect to("/setting")
    end
    @user = User.get(session[:user])
    @user.user_information.update(
      :display_name => params[:display_name],
      :first_name => params[:first_name],
      :last_name => params[:last_name],
      :country => params[:country],
      :city => params[:city],
      :bio => params[:bio]
    )
    flash[:notice] = "New personal information!"
    redirect to("/profile/#{session[:user]}")
  end

  def setting_social
    unless(params[:social_url] || params[:social_name])
       flash[:error] = "Are your created any thing?"
       return redirect("/auth/setting#social")
    end
    @user = User.get(session[:user])
    arr = (params[:social_url].values).zip(params[:social_name].values)
    for n in arr do # validation
      url = n[0].to_s
      if !(url =~ /\A#{URI::regexp(['http', 'https'])}\z/)
        flash[:error] = "Any url format are invalid #{url}"
        return redirect("/auth/setting#social") 
      elsif n[0].to_s.empty? || n[1].to_s.empty?
        flash[:error] = "Any field are empty"
        return redirect("/auth/setting#social")       
      end
    end
    @user.user_socials.destroy # delete all socials of the user
    for n in arr do # add record
      @user.user_socials.create(:url => n[0], :name => n[1])
    end
    flash[:notice] = "New social information!"
    redirect to("/profile/#{session[:user]}")
  end

  def setting_media_ajax(type)
    content_type 'application/json', :charset => 'utf-8' if request.xhr?

    if type == "photo" || type == "banner" then
      if !params[:file] || FastImage.type(params[:file][:tempfile]).nil? == true
        halt 200,  { :error => "Format invalid"}.to_json
      end
    else
        halt 200,  { :error => "Request error"}.to_json
    end
    @user = User.get(session[:user])
    if type == "photo"
      filename = upload_file(@user.id, settings.profiles_folder, params[:file][:filename], params[:file][:tempfile])
      @user.user_media.update(:profile_img_url => "profiles/" + filename)
      halt 200,  { :img_profile => @user.user_media.profile_img_url}.to_json
    elsif type == "banner"
      filename = upload_file(@user.id, settings.banners_folder, params[:file][:filename], params[:file][:tempfile])
      @user.user_media.update(:banner_img_url => "banners/" + filename)
      halt 200,  { :img_banner => @user.user_media.banner_img_url}.to_json         
    end
  end

  def delete_social
    @user = User.get(session[:user])
    if (@social = @user.user_socials.get(params[:id]) or halt 404, {:error => "Error"}) and @social.destroy!
      halt 200,  { :success => "Social link deleted!"}.to_json
    else
      halt 200,  { :error => "Error!"}.to_json
    end
  end

end
