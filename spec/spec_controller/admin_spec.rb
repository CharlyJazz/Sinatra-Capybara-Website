require 'spec_helper'
require 'rack/test'
require 'capybara/rspec'

RSpec.describe 'Admin Controller' do
  def app
      AdminController
  end

  describe "admin process", :type => :feature do
    # Creare todos estos registros para el mismo usuario id 1,
    # a excepcion de los comentarios, ya que tendran el id
    # del usario 2 pero su respetivo song o album estara
    # relacionado con el id del usuario 1

    # Probare si al eliminar un usuario se eliminan tambien
    # Todos los "orphan records" que quedaran con su id fantasma
    before do
      before_create_user :amount => 6 # 5 user
      before_create_social 3
      before_create_song 3
      before_create_comment_song 3, 2, 1
      before_create_album 3
      before_create_comment_album 3, 2, 1
    end

    it 'when delete user' do
      delete '/User',  {:data => "1"}
      expect(User.all.length).to eq 4
      expect(UserInformation.all.length).to eq 4
      expect(UserMedia.all.length).to eq 4
      expect(UserSocial.all.length).to eq 0
      expect(Song.all.length).to eq 0
      expect(Album.all.length).to eq 0
      expect(CommentAlbum.all.length).to eq 0
      expect(CommentSong.all.length).to eq 0
    end

    it 'when delete user_information' do
      delete '/UserInformation',  {:data => "1"}
      expect(UserInformation.all.length).to eq 4
    end

    it 'when delete user_media' do
      delete '/UserMedia',  {:data => "1"}
      expect(UserMedia.all.length).to eq 4
    end
    
    it 'when delete album' do
      delete '/Album',  {:data => "1"}
      expect(Album.all.length).to eq 2
    end

  end

end