require 'rack/test'
require 'rubygems'
require 'rack/test'
require 'rspec'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'database_cleaner'
require 'forgery'

require_relative 'before_helper'
require_relative 'action_helper'


ENV['RACK_ENV'] = 'test'

Dir.glob('./{helpers,controllers,models}/*.rb').each {|file| require file }

module FormHelpers
  def submit_form
    find('button[type="submit"]').click
  end
end

Capybara.app = Rack::Builder.new do
  map('/assets') {  run ApplicationController.sprockets }
  map('/tracks') { run Rack::Directory.new("./tracks") }
  map('/music') { run MusicController }
  map('/auth') { run AuthController }
  map('/admin') { run AdminController }
  map('/') { run WebsiteController }
end.to_app

Capybara.app_host = "http://localhost:8000"
Capybara.server_host = "localhost"
Capybara.server_port = "8000"
Capybara.raise_server_errors = true
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(
   app,
   :browser => :chrome,
   desired_capabilities: {
      "chromeOptions" => {
       "args" => %w{ window-size=1920,1080 no-sandbox user-data-dir=/root }
     }
    }
  )
end

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers

  config.expect_with :rspec do |c|
    c.syntax = :expect # expect vs should
  end

  config.include FormHelpers, :type => :feature
  config.include BeforeHelpers, :type => :feature
  config.include ActionHerlpers, :type => :feature

  # database_cleaner config...

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end