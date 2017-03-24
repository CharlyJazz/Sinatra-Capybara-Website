require 'sinatra/base'
require 'sinatra/extension'
require 'sinatra/flash'
require 'bcrypt'
require 'social_url'

require_relative '../models/models'
require_relative 'aplication_controller'

class AuthController < ApplicationController
  enable :method_override

  helpers AuthHelpers

  configure do
    set :profiles_folder, settings.root.join('assets', 'images/profiles')
    set :banners_folder, settings.root.join('assets', 'images/banners')
  end

  def set_title
    @title ||= "Authentication"
  end

  before do
    set_title
    set_current_user
  end

  get '/' do
    render :erb, :'auth/login'
  end

  post '/' do
    login_user
  end

  get '/change_password' do
    render :erb, :'auth/change_password'
  end

  post '/change_password' do
    update_password
  end

  get '/profile/:id' do
    @user = User.get(params[:id])
    if @user.class != User then redirect '/not_found' end
    @title = @user.username
    @songs = Song.all(:user_id => params[:id])

    render :erb, :'auth/profile'
  end

  get '/register' do
    render :erb, :'auth/register'
  end

  post '/register' do
    create_user
  end

  get '/setting' do
    @user = User.get(session[:user])
    render :erb, :'auth/setting'
  end

  post '/setting/:action' do
    if params[:action] == "social" then return setting_social end
    if params[:action] == "personal" then return setting_personal end
    if params[:action] == "media" then return setting_media else redirect '/not_found' end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end
end
