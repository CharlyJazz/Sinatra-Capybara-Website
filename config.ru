require 'sinatra/base'

Dir.glob('./{helpers,controllers,models}/*.rb').each {|file| require file }

map('/assets') {  run ApplicationController.sprockets }
map('/tracks') { run Rack::Directory.new("./tracks") }
map('/music') { run MusicController }
map('/auth') { run AuthController }
map('/admin') { run AdminController }
map('/') { run WebsiteController }
