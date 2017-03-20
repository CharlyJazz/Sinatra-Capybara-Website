require 'rack/test'
require 'rubygems'
require 'rack/test'
require 'rspec'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'

Dir.glob('./{helpers,controllers,models}/*.rb').each {|file| require file }

module FormHelpers
  def selector string
    # selector('#any_class').click
    find :css, string
  end
  def submit_form
    find('button[type="submit"]').click
  end
end

Capybara.app = ApplicationController

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FormHelpers, :type => :feature
  config.expect_with :rspec do |c|
    c.syntax = :expect # expect vs should
  end
  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers
end

=begin

Spec for controllers:      $ bundle exec rspec spec/spec_controller/file.rb
Spec for database models:  $ bundle exec rspec spec/spec_models/file.rb
Spec for any class:        $ bundle exec rspec spec/spec_class/file.rb

=end