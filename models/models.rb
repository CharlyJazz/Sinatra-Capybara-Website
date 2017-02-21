require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'
require 'dm-types'
require 'dm-validations'
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
  property :username, String, :length => 1..15
  property :email, String, :length => 6..125, :unique => true
  property :password, BCryptHash
  property :recover_password, String
  property :role, String, :default => 'user'
  # Add the image relations in version 2
  has n, :songs # => has n and belongs_to (or One-To-Many)
  has n, :albums # => has n and belongs_to (or One-To-Many)
end

class Album
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :date, Date
  # Add the image relations in version 2
  # Add the likes property in version 2
  has n, :songs, :through => Resource
  has n, :comment_albums # => has n and belongs_to (or One-To-Many)
                         # => CommentSong ----> comment_songs
  belongs_to :user
end

class Song
  # https://moodle2013-14.ua.es/moodle/pluginfile.php/73782/mod_resource/content/2/datamapper.org%20docs/docs/dm_more/types.html
  include DataMapper::Resource
  property :id, Serial
  property :url_song, Text
  property :title, Text
  property :description, Text
  property :genre, String
  property :type, Enum[:original, :remix, :live, :recording, :demo, :work, :effect, :other], :default => :original
  property :license, Enum[:creative_commons, :all_right_reserved]
  property :replay, Integer, :default => 0
  property :likes, Integer, :default => 0
  # Add the image relations in version 2
  has n, :albums, :through => Resource
  has n, :comment_songs # => has n and belongs_to (or One-To-Many)
                        # => CommentSong ----> comment_songs
  belongs_to :user
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
