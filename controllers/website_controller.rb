require 'sinatra/base'
require 'sinatra/extension'
require 'sinatra/flash'

require_relative '../models/models'
require_relative 'aplication_controller'

class WebsiteController < ApplicationController
  helpers WebsiteHelpers

  def set_title
    @title ||= "Frank Sinatra App"
  end

  before do
    set_title
    set_current_user
  end

  get '/' do
    @songs = Song.all(:limit => 5)
    @albums = Album.all(:limit => 4)
    @comments = search_comment_song
    erb :index
  end

end
