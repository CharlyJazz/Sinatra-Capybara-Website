require 'sinatra/base'
require 'sinatra/extension'
require 'sinatra/flash'
require_relative '../models/models'
require_relative 'aplication_controller'

class MusicController < ApplicationController
  enable :method_override

  helpers MusicHelpers

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

  get '/create' do
    render :erb, :'music/create'
  end

  post '/create' do
    puts params[:music]
    create_music
  end

end
