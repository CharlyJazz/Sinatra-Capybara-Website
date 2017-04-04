require 'sinatra/base'
require 'sinatra/extension'
require 'sinatra/flash'
require_relative '../models/models'
require_relative 'aplication_controller'

class MusicController < ApplicationController
  enable :method_override

  helpers MusicHelpers

  configure do
    set :music_folder, "./tracks"
  end

  def set_title
    @title ||= "Explorer Music"
  end

  before do
    set_title
    set_current_user
  end

  get '/' do
    find_songs
    render :erb, :'music/all'
  end

  get '/play/:id' do
    @song = find_song
    unless @song.class != Song
      song_social_link @song
      return render :erb, :'music/one'
    end
    redirect not_found
  end

  delete '/song/:id' do
    delete_song
  end

  get '/create/song' do
    render :erb, :'music/create_song'
  end

  post '/create/song' do
    create_music
  end


  get '/create/album' do
    find_song_by_user session[:user]
    render :erb, :'music/create_album'
  end  

  post '/create/album' do
    create_album
  end  

end
