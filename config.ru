require 'sinatra/base'

Dir.glob('./{helpers,controllers,models}/*.rb').each {|file| require file }

map('/song') { run SongController }
map('/auth') { run AuthController }
map('/') { run WebsiteController }
