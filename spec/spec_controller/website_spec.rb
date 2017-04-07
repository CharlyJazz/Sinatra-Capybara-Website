require 'spec_helper'
require 'rack/test'

RSpec.describe 'Website Controller' do
  def app
    WebsiteController
  end

  it 'Home' do
    get '/'
    expect(last_response.body).to_not eq("")
    expect(last_response).to be_ok
  end
end
