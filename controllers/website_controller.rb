require 'sinatra/base'
require 'sinatra/extension'
require 'sinatra/flash'

require_relative '../models/models'
require_relative 'aplication_controller'

class WebsiteController < ApplicationController
  def set_title
    @title ||= "Frank Sinatra"
  end

  before do
    set_title
    set_current_user
  end

  get '/' do
    erb :index
  end

end
