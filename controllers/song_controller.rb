require 'sinatra/base'
require 'sinatra/extension'
require 'sinatra/flash'
require_relative '../models/models'
require_relative 'aplication_controller'

class SongController < ApplicationController
  enable :method_override

  helpers SongHelpers

  def set_title
    @title ||= "Songs By Sinatra"
  end

  before do
    set_title
  end

  get '/' do
    find_songs
    slim :songs
  end

  get '/new' do
    @song = Song.new
    slim :new_song
  end

  post '/' do
    flash[:notice] = "Song successfully added" if create_song
    redirect to("/#{@song.id}")
  end

  get '/:id' do
    @song = find_song
    slim :show_song
  end


  get '/:id/edit' do
    @song = find_song
    slim :edit_song
  end

  put '/:id/edit' do
    song = Song.get(params[:id])
    song.update(params[:song])
    flash[:notice] = "Song successfully edited" if create_song
    redirect to("/#{song.id}")
  end

  delete '/:id' do
    if find_song.destroy
      flash[:notice] = "Song deleted"
    end
    redirect to("/")
  end

  post '/:id/like' do
    @song = find_song
    @song.likes = @song.likes.next # => this method is equal to ++
    @song.save
    redirect to("/#{@song.id}") unless request.xhr?
    slim :like, :layout => false
  end

end
