require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'
require 'sinatra'
require 'bcrypt'

# => http://datamapper.org/docs/associations.html

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

class Base
  include DataMapper::Resource
  property :id, Serial
  property :created_at, DateTime
  property :created_on, Date
  property :updated_at, DateTime
  property :updated_on, Date
end

class User < Base
  # => User authentication with email and password
  property :username, String, :length => 1..15
  property :email, String, :length => 6..125, :unique => true
  property :password_hash, String
  property :password_salt, String
  property :recover_password, String
  property :role, String, :default => 'user', :accessor =>  :protected
  # Add the image relations in version 2
end

class Album < Base
  property :name, String
  property :date, Date
  # Add the image relations in version 2
  # Add the likes property in version 2
  has n, :songs, :through => Resource
  has n, :comment_albums # => has n and belongs_to (or One-To-Many)
                         # => CommentSong ----> comment_songs
end

class Song < Base
  property :title, String
  property :lyrics, Text
  property :length, Integer
  property :released_on, Date
  property :likes, Integer, :default => 0

  def released_on=date
    super Date.strptime(date, '%m/%d/%Y')
  end
  has n, :albums, :through => Resource
  has n, :comment_songs # => has n and belongs_to (or One-To-Many)
                        # => CommentSong ----> comment_songs
end

class CommentAlbum
  include DataMapper::Resource
  property :id, Serial
  property :text, String
  property :likes, Integer, :default => 0

  belongs_to :album
end

class CommentSong
  include DataMapper::Resource
  property :id, Serial
  property :text, String
  property :likes, Integer, :default => 0

  belongs_to :song
end

DataMapper.finalize.auto_upgrade!
