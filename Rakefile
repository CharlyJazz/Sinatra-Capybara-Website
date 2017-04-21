Bundler.setup
require 'date'
Dir.glob('./{models}/*.rb').each {|file| require file }

begin
  # bundle exec rake "admin:create"
  namespace :admin do
    task :create do
      create_admin
    end
  end
end

class String
  def is_number?
    true if Float(self) rescue false
  end
end

def create_admin
  puts "You will be prompted to enter an username, email and password for the new admin"
  puts "Username: "
  username = STDIN.gets.chomp
  puts "Email: "
  email = STDIN.gets.chomp
  puts "Password: "
  password = STDIN.gets.chomp
  puts "Repeat password: "
  repeat = STDIN.gets.chomp
  if username.is_number?
    puts "Sorry, the username need more letters."
    return
  end
  unless password == repeat
    puts "Sorry, password not matches."
    return
  end
  unless email.to_s.empty? || username.to_s.empty? || password.to_s.empty?
      if @user = User.create(:username => username,
                             :email => email, 
                             :password => password,
                             :role => :admin)
        @user.user_media = UserMedia.create
        @user.user_information = UserInformation.create
        @user.save
        @user.user_media.save
        @user.user_information.save  
        DataMapper.finalize.auto_upgrade!
        puts "The admin was created successfully...
              Admin: #{username} Date: #{DateTime.now}"
      else
        puts "Sorry, the admin was not created!"
      end
  end
end
