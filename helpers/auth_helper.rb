module AuthHelpers
  def create_user
    @user = User.create(params[:user])
    flash[:notice] = "User successfully signed!"
    redirect '/auth'
  end

  def login_user
    @user = User.first(:email => params[:email])
    if @user.class != User
      flash[:notice] = "The email no are correct"
      redirect '/auth'
    end
    if @user.password == params[:password]
      session[:user] = @user.id
      flash[:notice] = "User successfully logged"
      redirect "auth/profile/#{session[:user]}"
    else
      flash[:notice] = "The email or password no are correct"
      redirect '/auth'
    end
  end

  def update_password
    if params[:recover_password].to_s.empty? or
       params[:password_old].to_s.empty? or
       params[:password_new].to_s.empty?
      flash[:notice] = "You send a empty field..."
      return redirect 'auth/change_password'
    end
    @user = User.first(:recover_password => params[:recover_password])
    if @user.class != User or @user.password != params[:password_old]
      flash[:notice] = "Yours dates not are corrects"
      redirect 'auth/change_password'
    else
      @user.update(:password => params[:password_new])
      flash[:notice] = "Your secret is correct, your password changed"
      redirect 'auth/change_password'
    end
  end
  # Create method access admin
end
