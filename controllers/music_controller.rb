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
      return render :erb, :'music/one'
    end
    redirect not_found
  end

  delete '/song/:id' do
    delete_song
  end

  get '/create' do
    render :erb, :'music/create'
  end

  post '/create' do
    create_music
  end

end
