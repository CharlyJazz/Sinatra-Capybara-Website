require 'rack/test'
require 'rubygems'
require 'rack/test'
require 'rspec'

Dir.glob('./{helpers,controllers,models}/*.rb').each {|file| require file }

RSpec.configure do |config|
  config.include Rack::Test::Methods
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/development.db")
  DataMapper.finalize
  # <model name>.auto_migrate!
end
