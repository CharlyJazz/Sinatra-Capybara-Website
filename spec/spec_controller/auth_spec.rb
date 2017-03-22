require 'spec_helper'
require 'rack/test'
require 'capybara/rspec'

RSpec.describe 'Website' do
  def app
    AuthController
  end

  it 'when get login' do
    get '/'
    expect(last_response.body).to_not eq("")
    expect(last_response).to be_ok
  end

  it 'when get profile with id 1' do
    get '/profile/1'
    expect(last_response.body).to_not eq("")
    expect(last_response).to be_ok
  end

  it 'when get change_password' do
    get '/change_password'
    expect(last_response.body).to_not eq("")
    expect(last_response).to be_ok
  end
end