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
    set :song_image_folder, settings.root.join('assets', 'images/songs')
    set :album_image_folder, settings.root.join('assets', 'images/albums')
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
    render :erb, :'music/songs'
  end

  get '/song/:id' do
    @song = find_song
    unless @song.class != Song
      social_link @song
      return render :erb, :'music/song'
    end
    redirect not_found
  end

  delete '/song/:id' do
    delete_song
  end

  post '/song/edit/:id' do
    # params[type] all or image
    edit_song_ajax(params[:type], params[:id])
  end

  get '/create/song' do
    render :erb, :'music/create_song'
  end

  post '/song/replay' do
    add_replay_ajax
  end

  post '/create/song' do
    create_music
  end

  get '/album/:id' do
    @album = find_album
    unless @album.class != Album
      social_link @album
      @user = User.get(@album.user_id)
      return render :erb, :'music/album'
    end
    redirect not_found    
  end

  delete '/album/:id' do
    delete_album
  end

  post '/album/edit/:id' do
    # params[type] all or image
    edit_album_ajax(params[:type], params[:id])
  end  

  get '/create/album' do
    find_song_by_user session[:user]
    render :erb, :'music/create_album'
  end  

  post '/create/album' do
    create_album
  end

end
