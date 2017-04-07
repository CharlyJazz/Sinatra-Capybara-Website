require 'spec_helper'
require 'rack/test'

RSpec.describe 'Music Controller' do
  def app
    MusicController
  end

  it 'when get all song' do
    get '/'
    expect(last_response.body).to_not eq("")
    expect(last_response).to be_ok
  end

  it 'when get create song' do
    get '/create'
    expect(last_response.body).to_not eq("")
    expect(last_response).to be_ok
  end

  describe 'when get play song with id 1' do
    before do
      before_create_user
      before_create_songs 1
      @song = Song.get(1)
    end
    if @song.instance_of? Song then
        it 'when the record exist' do
          get '/play/1'
          expect(last_response).to be_ok
        end
    else
        it 'when the record not exist' do
          get '/play/1'
          expect(last_response).to_not be_ok
        end
    end
  end
end
