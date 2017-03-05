module Apphelpers

  def asset_path(source)
    "/assets/" + settings.sprockets.find_asset(source).digest_path
  end

  def current_user
    if session[:user]
      user = User.first(:id => session[:user])

      if user.role == 'user'
        return AuthUser.new(user.username)
      end

      if user.role == 'admin'
        return Admin.new(user.username)
      end

    else
      return GuestUser.new
    end

    rescue NoMethodError
      return GuestUser.new

  end

  def set_current_user
    @current_user = current_user
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

  def upload_file(directory, filename, tmpfile)
    path = File.join(directory, filename)
    File.open(path, "wb") { |f| f.write(tmpfile.read) }
  end
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
  def initialize(name)
    @name = name
  end

  def permission_level
    1
  end

  def is_authenticated
    true
  end

  def name
    @name
  end

  # current_user.admin? returns false. current_user.has_a_baby? returns false.
  # (which is a bit of an assumption I suppose)
  def method_missing(m, *args)
    return false
  end
end

class Admin
  def initialize(name)
    @name = name
  end

  def permission_level
    2
  end

  def is_authenticated
    true
  end

  def name
    @name
  end
  # current_user.admin? returns false. current_user.has_a_baby? returns false.
  # (which is a bit of an assumption I suppose)
  def method_missing(m, *args)
    return false
  end
end
