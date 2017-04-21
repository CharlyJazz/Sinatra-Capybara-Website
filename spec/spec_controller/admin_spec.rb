require 'spec_helper'
require 'rack/test'
require 'capybara/rspec'

RSpec.describe 'Admin Controller' do
  def app
      AdminController
  end

  describe "admin delete any model", :type => :feature do
    before do
      before_create_user(:amount => 6) # 5
      before_create_social 3
      before_create_song 3
      before_create_comment_song 3, 2, 1  # parameters: n, song_id, user_id
      before_create_album 3
      before_create_comment_album 3, 2, 1 # parameters: n, album_id, user_id
    end

    it 'when delete user' do
      delete '/User',  {:data => "1"}
      expect(User.all.length).to eq 4
      expect(UserInformation.all.length).to eq 4
      expect(UserMedia.all.length).to eq 4
      expect(UserSocial.all.length).to eq 0 # Almost all models have the id 1
      expect(Song.all.length).to eq 0
      expect(Album.all.length).to eq 0
      expect(CommentAlbum.all.length).to eq 0
      expect(CommentSong.all.length).to eq 0
    end

    it 'when delete user_information' do
      delete '/UserInformation',  {:data => "1"}
      expect(User.all.length).to eq 5
      expect(UserInformation.all.length).to eq 4
    end

    it 'when delete user_media' do
      delete '/UserMedia',  {:data => "1"}
      expect(User.all.length).to eq 5
      expect(UserMedia.all.length).to eq 4
    end
    
    it 'when delete album' do
      delete '/Album',  {:data => "1"}
      expect(User.all.length).to eq 5      # Should not affect this model
      expect(Song.all.length).to eq 3      # Should not affect this model
      expect(Album.all.length).to eq 2     # Should yes affect this model
      expect(AlbumTag.all.length).to eq 2
      expect(AlbumSong.all.length).to eq 2
    end

    it 'when delete comments of album' do
      delete '/CommentAlbum', {:data => "1,2,3"}
      expect(User.all.length).to eq 5      # Should not affect this model
      expect(Album.all.length).to eq 3     # Should not affect this model
      expect(Song.all.length).to eq 3      # Should not affect this model
      expect(CommentAlbum.all.length).to eq 0
    end      

    it 'when delete song' do
      delete '/Song', {:data => "2"}
      expect(User.all.length).to eq 5      # Should not affect this model
      expect(Album.all.length).to eq 3     # Should not affect this model
      expect(Song.all.length).to eq 2
      expect(CommentSong.all(:song_id => 2).length).to eq 0
    end

    it 'when delete comments of song' do
      delete '/CommentSong', {:data => "1,2,3"}
      expect(User.all.length).to eq 5      # Should not affect this model
      expect(Album.all.length).to eq 3     # Should not affect this model
      expect(Song.all.length).to eq 3      # Should not affect this model
      expect(CommentSong.all.length).to eq 0
    end

  end

end