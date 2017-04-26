require 'sinatra/base'
require 'sinatra/extension'
require 'sinatra/flash'
require 'bcrypt'
require_relative '../lib/sinatra/admin'
require_relative '../models/models'
require_relative 'aplication_controller'

class AdminController < ApplicationController
  enable :method_override
  register Sinatra::AdminView

  def set_title
    @title ||= "Admin"
  end

  before do
    set_title
    set_current_user
  end

  add_model_in_view(args:[User,UserMedia, UserInformation, UserSocial,
                          Song, CommentSong, Album, CommentAlbum, AlbumTag,
                          AlbumSong])
  
  add_many_to_many_no_delete_model(:model_delete => Album, :model_life => Song)

end
