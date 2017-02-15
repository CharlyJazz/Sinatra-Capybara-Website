require 'sinatra/base'

Dir.glob('./{helpers,controllers,models}/*.rb').each {|file| require file }

map('/public'){run Rack::Directory.new("./public")}
map('/songs') { run SongController }
map('/') { run WebsiteController }
