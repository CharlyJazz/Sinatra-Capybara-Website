require 'spec_helper'
require 'rack/test'
require 'capybara/rspec'

RSpec.describe 'Admin Front-End' do
  def app
    AdminController
  end

  describe "Admin delete record:", :type => :feature do

    before do
      Capybara.default_driver = :selenium
      Capybara.default_max_wait_time = 5
      before_create_user(:username => "admin_user", :email => "admin@gmail.com", :password => "password", :amount => 1, :role => :admin)
      before_create_user(:amount => 5)
      before_create_song 7
    end

    it "when delete user records" do
      action_login("admin@gmail.com", "password")
      visit '/admin'
      click_link('User')
      page.execute_script "$('#input-hidden-id-models').show()"
      4.times do | n |
        within('.form-checkbox-' + (n + 2).to_s) do
          find('[for=filled-in-' + (n + 2).to_s + ']').click
        end
      end
      find(:css, 'a.delete-model > i.material-icons').click
      wait_for_ajax
      visit '/admin'
      click_link('User')
      expect(page).to have_selector('tr.tr-model', count: 1)
    end

    it "when delete song records" do
      action_login("admin@gmail.com", "password")
      visit '/admin'
      click_link('Song')
      page.execute_script "$('#input-hidden-id-models').show()"
      4.times do | n |
        within('.form-checkbox-' + (n + 1).to_s) do
          find('[for=filled-in-' + (n + 1).to_s + ']').click
        end
      end
      find(:css, 'a.delete-model > i.material-icons', wait: 10).click
      wait_for_ajax
      visit '/admin'
      click_link('Song')      
      expect(page).to have_selector('tr.tr-model', count: 3)
    end
  end

  describe "Admin delete user:", :type => :feature do
    before do
      Capybara.default_driver = :selenium
      Capybara.default_max_wait_time = 5
      before_create_user(:username => "admin_user", :email => "admin@gmail.com",
                         :password => "password", :amount => 1, :role => "admin")
      4.times { UserSocial.create(:user_id => 1 ) }
      Song.create(:user_id => 1)
      Album.create(:user_id => 1)
      CommentSong.create(:user_id => 1, :song_id=> 1)
      CommentAlbum.create(:user_id => 1, :album_id  => 1)
    end

    it "when delete User and verify" do
      action_login("admin@gmail.com", "password")      
      visit '/admin'
      click_link('User')
        within('.form-checkbox-1') do
          find('[for=filled-in-1]').click
        end
      find(:css, 'a.delete-model > i.material-icons').click
      wait_for_ajax        
      expect(User.all.length).to eq 0
      expect(UserInformation.all.length).to eq 0
      expect(UserMedia.all.length).to eq 0
      expect(UserSocial.all.length).to eq 0 # Almost all models have the id 1
      expect(Song.all.length).to eq 0
      expect(Album.all.length).to eq 0
      expect(CommentAlbum.all.length).to eq 0
      expect(CommentSong.all.length).to eq 0                
    end

  end

  describe "Admin create record" do
    before do
      Capybara.default_driver = :selenium
      Capybara.default_max_wait_time = 5
      before_create_user(:username => "admin_user", :email => "admin@gmail.com", :password => "password", :amount => 1, :role => :admin)
    end                              
    
    it 'when create user' , :type => :feature do
      action_login("admin@gmail.com", "password")      
      visit '/admin/create/User'
      within('form') do
          fill_in 'username', with: Forgery(:internet).user_name
          fill_in 'email', with: Forgery(:email).address
          fill_in 'password', with: Forgery(:basic).password
          fill_in 'recover_password', with: Forgery(:lorem_ipsum).words(5)
      end
      submit_form
      page.has_selector?('form')
      expect(User.all.length).to eq 2
    end

    it 'when create user information' , :type => :feature do
      # se envia por create pero es update porque ya existe
      action_login("admin@gmail.com", "password")      
      visit '/admin/create/UserInformation'
      within('form') do
          fill_in 'user_id', with: 1        
          fill_in 'display_name', with: Forgery(:internet).user_name
          fill_in 'first_name', with: Forgery(:name).female_first_name	
          fill_in 'last_name', with: Forgery(:name).last_name	
          fill_in 'country', with: Forgery(:address).country
          fill_in 'country', with: Forgery(:address).country	
          fill_in 'city', with: Forgery(:address).city
          fill_in 'bio', with: Forgery(:lorem_ipsum).words(10)
      end
      submit_form
      page.has_selector?('form')
      expect(User.all.length).to eq 1
      expect(UserInformation.all.length).to eq 1 # One to One should update
    end

    it 'when create user media' , :type => :feature do
      # This test should be fail
      action_login("admin@gmail.com", "password")            
      visit '/admin/create/UserMedia'
      within('form') do
          fill_in 'user_id', with: 1        
          attach_file("profile_img_url", File.absolute_path('./assets/images/songs/default_song.png'), { make_visible: true })
          attach_file("banner_img_url", File.absolute_path('./assets/images/songs/default_song.png'), { make_visible: true })
      end
      submit_form
      page.has_selector?('form')
      expect(User.all.length).to eq 1
      expect(UserMedia.all.length).to eq 1 # One to One should update
      expect(UserMedia.get(1).profile_img_url).to eq "1_default_song.png" #TODO CREAR FUNCION PARA SUBIR ARCHIVOS
      expect(UserMedia.get(1).profile_img_url).to eq "1_default_song.png"
    end

    it 'when create user social links' , :type => :feature do
      action_login("admin@gmail.com", "password")            
      visit '/admin/create/UserSocial'
      3.times { | n |
        within('form') do
            fill_in 'user_id', with: 1
            fill_in 'url', with: "https://www.socialweb.com/chorizo"
            fill_in 'name', with: "chorizo in socialweb"          
        end
        submit_form
        if n < 3 - 1 then visit '/admin/create/UserSocial' end
      }
      page.has_selector?('form')
      expect(User.get(1).user_socials.count).to eq 3
    end 

    it 'when create album', :type => :feature do
      action_login("admin@gmail.com", "password")            
      visit '/admin/create/Album'
      within('form') do
          fill_in 'user_id', with: 1
          fill_in 'name', with: Forgery(:lorem_ipsum).words(5)
          fill_in 'description', with: Forgery(:lorem_ipsum).words(5)
          fill_in 'date', with: Forgery(:date).date
      end
      submit_form
      page.has_selector?('form')
      expect(User.get(1).albums.count).to eq 1      
      expect(Album.all.length).to eq 1
    end

    it 'when create song', :type => :feature do
      action_login("admin@gmail.com", "password")   
      visit '/admin/create/Song'
      within('form') do
        fill_in 'title', with: Forgery(:lorem_ipsum).words(5)
        fill_in 'description', with: Forgery(:lorem_ipsum).words(5)
        fill_in 'genre', with: Forgery(:lorem_ipsum).words(1)
        fill_in 'replay', with:  Forgery(:basic).number
        fill_in 'likes', with:  Forgery(:basic).number        
      end
      submit_form
      page.has_selector?('form')
      expect(User.get(1).songs.count).to eq 1
      expect(Song.all.length).to eq 1
    end      

    it 'when create album tag', :type => :feature do
      action_login("admin@gmail.com", "password")   
      visit '/admin/create/AlbumTag'
      3.times { |n|
      within('form') do
        fill_in 'album_id', with: 1        
        fill_in 'name', with: Forgery(:lorem_ipsum).words(1)
      end
      submit_form
        if n < 3 - 1 then visit '/admin/create/AlbumTag' end      
      }
      page.has_selector?('form')
      expect(AlbumTag.all.length).to eq 3
    end 

    it 'when create Comment for album', :type => :feature do
      action_login("admin@gmail.com", "password")   
      visit '/admin/create/CommentAlbum'
      within('form') do
        fill_in 'text', with: Forgery(:lorem_ipsum).words(10)
        fill_in 'album_id', with: Forgery(:basic).number
        fill_in 'user_id', with: Forgery(:basic).number      
      end
      submit_form
      page.has_selector?('form')
      expect(CommentAlbum.all.length).to eq 1
    end

    it 'when create Comment for song', :type => :feature do
      action_login("admin@gmail.com", "password")   
      visit '/admin/create/CommentSong'
      within('form') do
        fill_in 'text', with: Forgery(:lorem_ipsum).words(10)
        fill_in 'song_id', with: Forgery(:basic).number
        fill_in 'user_id', with: Forgery(:basic).number      
      end
      submit_form
      page.has_selector?('form')
      expect(CommentSong.all.length).to eq 1
    end    

  end

end