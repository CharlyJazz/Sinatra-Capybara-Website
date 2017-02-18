require 'sinatra/base'
require 'sinatra/extension'
require 'sinatra/flash'
require 'bcrypt'
require_relative '../models/models'
require_relative 'aplication_controller'

class AuthController < ApplicationController
  enable :method_override

  helpers AuthHelpers

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

  get '/profile/:id' do
    # => If redirect of login:
    # => params[:id] is session[:user]
    @user = User.get(params[:id])
    # => Si no hay usuario con ese id :
    if @user.class != User
      redirect '/not_found'
    end
    render :erb, :'auth/profile'
  end

  get '/register' do
    render :erb, :'auth/register'
  end

  post '/register' do
    create_user
  end

  get '/logout' do
    session.clear
    redirect '/'
  end
end
