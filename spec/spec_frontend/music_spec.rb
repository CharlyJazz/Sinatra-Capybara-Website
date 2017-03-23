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
      before_create_user
      before_create_songs 5
    end

    it "when have songs in the profile" do
      action_login

      click_link('charlytester')
      click_link('Profile')
      click_link('Tracks')
      page.execute_script "window.scrollBy(0,10000)"
      expect(page).to have_selector('div.song__wrapper', count: 5)
      expect(page).to have_content 'Song number'
    end

    it "when delete any song" do
      action_login

      click_link('charlytester')
      click_link('Profile')
      click_link('Tracks')
      find("a[data-id-song='1']").click
      click_button('Yes, delete')
      click_link('Tracks')
      page.execute_script "window.scrollBy(0,10000)"
      expect(page).to have_selector('div.song__wrapper', count: 4)
    end

  end

end