module AuthHelpers

  def current_user
    if session[:user]
      user = User.first(:id => session[:user])

      if user.role == 'user'
        AuthUser.new
      end

      if user.role == 'admin'
        Admin.new
      end

    else
      GuestUser.new
    end

  end

  def logged_in?
    !!session[:user]
  end

  def login_required
    user = current_user
    if user && user.class != GuestUser
      return true
    else
      redirect '/login'
      return false
    end
  end

  def create_user
    @user = User.new(params[:user])
    password_salt = BCrypt::Engine.generate_salt
    password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
    @user.password_salt = password_salt
    @user.password_hash = password_hash
    @user.save!
    flash[:notice] = "User successfully signed!"
    redirect '/auth'
  end

  def login_user
    @user = User.first(:email => params[:email])
    if @user.class != User
      flash[:notice] = "The email no are correct"
      redirect '/auth'
    end
    if @user.password_hash == BCrypt::Engine.hash_secret(params[:password], @user.password_salt)
      session[:user] = @user.id
      flash[:notice] = "User successfully logged"
      redirect "/profile/#{session[:user]}"
    else
      flash[:notice] = "The email or password no are correct"
      redirect '/auth'
    end
  end
  # Create metodo para saber si es un admin
end

class GuestUser
  def permission_level
    0
  end

  def is_anonimous
    true
  end
  # current_user.admin? returns false. current_user.has_a_baby? returns false.
  # (which is a bit of an assumption I suppose)
  def method_missing(m, *args)
    return false
  end
end

class AuthUser
  def permission_level
    1
  end

  def is_authenticated
    true
  end
  # current_user.admin? returns false. current_user.has_a_baby? returns false.
  # (which is a bit of an assumption I suppose)
  def method_missing(m, *args)
    return false
  end
end

class Admin
  def permission_level
    2
  end

  def is_authenticated
    true
  end
  # current_user.admin? returns false. current_user.has_a_baby? returns false.
  # (which is a bit of an assumption I suppose)
  def method_missing(m, *args)
    return false
  end
end
