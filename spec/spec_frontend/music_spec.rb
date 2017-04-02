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
      Capybara.default_wait_time = 5
      before_create_user("charlytester", "charlyjazzc1@gmail.com", "password")
      before_create_songs 5
    end

    it "when have songs in the profile" do
      action_login("charlyjazzc1@gmail.com", "password")
      click_link('charlytester')
      click_link('Profile')
      click_link('Tracks')
      page.execute_script "window.scrollBy(0,10000)"
      expect(page).to have_selector('div.song__wrapper', count: 5)
    end

    it "when delete any song in profile" do
      action_login("charlyjazzc1@gmail.com", "password")
      click_link('charlytester')
      click_link('Profile')
      click_link('Tracks')
      find("a[data-id-song='1']").click
      click_button('Yes, delete')
      click_link('Tracks')
      page.execute_script "window.scrollBy(0,10000)"
      expect(page).to have_selector('div.song__wrapper', count: 4)
    end

    it "when delete any song in play" do
      action_login("charlyjazzc1@gmail.com", "password")
      visit '/music/play/1'
      find(:css, 'a.pre-delete-song').click
      click_button('Yes, delete')
      expect(page).to have_content 'Song deleted'
    end

    it "when create album" do
      action_login("charlyjazzc1@gmail.com", "password")
      visit '/music/create/album'
      4.times do | n |
        find("a[data-id-song='" + (n + 1).to_s+ "']").click
      end
    end
  end
end
