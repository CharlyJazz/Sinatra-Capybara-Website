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
  # helpers AdminHelpers

  configure do
    # set :profiles_folder, settings.root.join('assets', 'images/profiles')
    # set :banners_folder, settings.root.join('assets', 'images/banners')
  end

  def set_title
    @title ||= "Admin"
  end


  before do
    set_title
    set_current_user
  end

  add_model_in_view(args:[User,UserMedia, UserInformation, UserSocial,
                          Song, CommentSong, Album, CommentAlbum])

end
