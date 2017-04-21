require 'data_mapper' # => http://datamapper.org/docs/associations.html
require 'sinatra'

configure :test do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/test.db")
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

class User
  include DataMapper::Resource
  property :id, Serial
  property :username, String, :length => 1..15
  property :email, String, :length => 6..125, :unique => true, :format => :email_address
  property :password, BCryptHash
  property :recover_password, String
  property :role, DataMapper::Property::Enum[:user, :admin], :default => :user
  property :created_at, String, :length => 25..50
  property :updated_at, String, :length => 25..50

  has 1, :user_information # => (One-to-One)
  has 1, :user_media       # => (One-to-One)
  has n, :user_socials     # => has n and belongs_to (or One-To-Many)
  has n, :songs            # => has n and belongs_to (or One-To-Many)
  has n, :albums           # => has n and belongs_to (or One-To-Many)
  has n, :comment_albums   # => has n and belongs_to (or One-To-Many)
  has n, :comment_songs    # => has n and belongs_to (or One-To-Many)
  has n, :user_like_songs


  after :save do
    self.created_at = DateTime.now().to_s
  end

  after :update do
    self.updated_at = DateTime.now().to_s
  end
  
end

class UserMedia
  include DataMapper::Resource
  property :id, Serial  
  property :profile_img_url, FilePath, :default => "profiles/default_profile.jpg", :lazy => false
  property :banner_img_url, FilePath, :default => "banners/default_banner.jpg", :lazy => false
  property :updated_at, String, :length => 25..50

  belongs_to :user, :key => true

  after :update do
    self.updated_at = DateTime.now().to_s
  end
  
end

class UserInformation
  include DataMapper::Resource
  property :id, Serial  
  property :display_name, String, :length => 2..50
  property :first_name, String, :length => 2..50
  property :last_name, String, :length => 2..50
  property :country, String, :length => 2..50
  property :city, String, :length => 2..50
  property :bio, Text, :length => 10..225, :lazy => false
  property :updated_at, String, :length => 25..50

  belongs_to :user, :key => true

  after :update do
    self.updated_at = DateTime.now().to_s
  end
  
end

class UserSocial
  include DataMapper::Resource
  property :id, Serial
  property :url, Text, :lazy => false
  property :name, String
  property :created_at, String, :length => 25..50
  property :updated_at, String, :length => 25..50

  belongs_to :user

  after :save do
    self.created_at = DateTime.now().to_s
  end

  after :update do
    self.updated_at = DateTime.now().to_s
  end
  
end

class Album
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :date, String
  property :description, String
  property :album_img_url, FilePath, :default => "albums/default_album.jpg", :lazy => false
  property :created_at, String, :length => 25..50
  property :updated_at, String, :length => 25..50  
 
  has n, :songs, :through => Resource
  has n, :album_tags
  has n, :comment_albums # => has n and belongs_to (or One-To-Many)
                         # => CommentSong ----> comment_songs
  belongs_to :user

  after :save do
    self.created_at = DateTime.now().to_s
  end

  after :update do
    self.updated_at = DateTime.now().to_s
  end
  
end

class AlbumTag
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :created_at, String, :length => 25..50
  property :updated_at, String, :length => 25..50  
  
  belongs_to :album

  after :save do
    self.created_at = DateTime.now().to_s
  end

  after :update do
    self.updated_at = DateTime.now().to_s
  end
  
end

class Song
  include DataMapper::Resource
  property :id, Serial
  property :url_song, FilePath # File music url
  property :title, String
  property :description, String
  property :genre, String
  property :type, DataMapper::Property::Enum[:original, :remix, :live, :recording, :demo, :work, :effect, :other], :default => :original
  property :license, DataMapper::Property::Enum[:creative_commons, :all_right_reserved]
  property :replay, Integer, :default => 0
  property :likes, Integer, :default => 0
  property :song_img_url, FilePath, :default => "songs/default_song.png", :lazy => false
  property :created_at, String, :length => 25..50
  property :updated_at, String, :length => 25..50  

  has n, :albums, :through => Resource
  has n, :user_like_songs
  has n, :comment_songs # => has n and belongs_to (or One-To-Many), CommentSong ----> comment_songs
  belongs_to :user

  after :save do
    self.created_at = DateTime.now().to_s
  end

  after :update do
    self.updated_at = DateTime.now().to_s
  end
  
end

class UserLikeSong
  include DataMapper::Resource
  property :id, Serial

  belongs_to :song
  belongs_to :user

end
  

class CommentAlbum
  include DataMapper::Resource
  property :id, Serial
  property :text, String, :length => 5..100
  property :created_at, String, :length => 25..50
  property :updated_at, String, :length => 25..50  

  belongs_to :album
  belongs_to :user

  after :save do
    self.created_at = DateTime.now().to_s
  end

  after :update do
    self.updated_at = DateTime.now().to_s
  end
  
end

class CommentSong
  include DataMapper::Resource
  property :id, Serial
  property :text, String, :length => 5..100
  property :created_at, String, :length => 25..50
  property :updated_at, String, :length => 25..50  

  belongs_to :song
  belongs_to :user

  after :save do
    self.created_at = DateTime.now().to_s
  end

  after :update do
    self.updated_at = DateTime.now().to_s
  end
  
end

DataMapper.finalize.auto_upgrade!