require 'spec_helper'
require 'rack/test'
require 'capybara/rspec'

RSpec.describe 'Website' do
  def app
    MusicController
  end

  describe "\nTracks, Albumes, Tracks Likes in the profile:", :type => :feature do
    before do
      Capybara.default_driver = :selenium
      Capybara.default_wait_time = 2
      before_create_user
      before_create_songs 5
    end

    it "when have songs in the profile" do
      visit '/auth/profile/1'
      click_link('Tracks')
      expect(page).to have_content 'Song number'
    end

  end

end