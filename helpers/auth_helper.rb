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
  # Create method access admin
end
