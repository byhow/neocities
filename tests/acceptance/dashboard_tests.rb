require_relative './environment.rb'

describe 'dashboard' do
  describe 'create directory' do

    describe 'logged in' do
      include Capybara::DSL
      include Capybara::Minitest::Assertions

      before do
        Capybara.reset_sessions!
        @site = Fabricate :site
        page.set_rack_session id: @site.id
      end

      it 'records a dashboard access' do
        _(@site.reload.dashboard_accessed).must_equal false
        visit '/dashboard'
        _(@site.reload.dashboard_accessed).must_equal true
      end

      it 'creates a base directory' do
        visit '/dashboard'
        click_link 'New Folder'
        fill_in 'name', with: 'testimages'
        #click_button 'Create'
        all('#createDir button[type=submit]').first.click
        _(page).must_have_content /testimages/
        _(File.directory?(@site.files_path('testimages'))).must_equal true
      end

      it 'creates a new file' do
        random = SecureRandom.uuid.gsub('-', '')
        visit '/dashboard'
        click_link 'New File'
        fill_in 'filename', with: "#{random}.html"
        #click_button 'Create'
        all('#createFile button[type=submit]').first.click
        _(page).must_have_content /#{random}\.html/
        _(File.exist?(@site.files_path("#{random}.html"))).must_equal true
      end
    end
  end
end
