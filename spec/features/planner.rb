require 'rails_helper'

if Capybara.javascript_driver == :webkit
  require 'capybara/webkit/matchers'
end

describe "the planner module", :type => :feature, :js => true do
  it "allows you to visit the main index" do
    login
    visit "/planner"

    expect(page).to have_content "Month"

    page.driver.browser.save_screenshot 'planner-index.png'

    expect(page).not_to have_errors if Capybara.javascript_driver == :webkit
  end
end
