require 'sinatra/base'
require 'sinatra/extension'
require 'sinatra/flash'
require_relative '../models/models'
require_relative 'aplication_controller'

class SongController < ApplicationController
  enable :method_override

  helpers SongHelpers

  def set_title
    @title ||= "Songs By Frank Sinatra"
  end

  before do
    set_title
    set_current_user
  end

end
