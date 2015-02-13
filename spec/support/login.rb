module Login
  def login
    visit "/login"
    within(".log-in-box") do
      fill_in 'username', :with => 'demo@constructionmanager.net'
      fill_in 'password', :with => 'Password1'
    end
    click_button 'Log In'

    wait_for_ajax
  end
end

RSpec.configure do |config|
  config.include Login, type: :feature
end