require 'rails_helper'

describe "the signin process", :type => :feature, :js => true do
  it "rejects invalid credentials" do
    visit "/login"
    within(".log-in-box") do
      fill_in 'username', :with => 'demo@constructionmanager.net'
      fill_in 'password', :with => 'ThisIsTheWrongPassword'
    end
    click_button 'Log In'
    wait_for_ajax
    expect(page.find("#log-in-button")).to have_content 'Invalid username or password'
  end

  it "rejects accepts user logins" do
    login
    
    expect(page).to have_content 'Welcome'
  end
end
