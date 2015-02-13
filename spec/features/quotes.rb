require 'rails_helper'

if Capybara.javascript_driver == :webkit
  require 'capybara/webkit/matchers'
end

describe "the quotes module", :type => :feature, :js => true do
  it "allows you to visit the main index" do
    login
    visit "/quotes"

    expect(page).to have_content 'Number'

    page.driver.browser.save_screenshot 'quotes-index.png'

    expect(page).not_to have_errors if Capybara.javascript_driver == :webkit
  end

  it "allows you to create a new quote" do
    login
    visit "/quotes"

    find(".sub-menu-bar li:first-child a").click

    expect(page).to have_content 'New Quote'

    # Fill in the quote
    fill_in "quotenotes", :with => 'Test notes'

    click_button "SAVE"

    expect(page).not_to have_errors if Capybara.javascript_driver == :webkit

    wait_for_ajax

    expect(page).to have_content("Editing Quote")
    expect(find("#quotenotes")).to have_content("Test notes")
  end

  it "allows you to update a quote" do
    login
    visit "/quotes"

    find("#quotes-grid tbody tr:first-child").double_click
    wait_for_ajax

    expect(page).to have_content("Editing Quote")

     # Fill in the quote
    fill_in "quotenotes", :with => 'Test notes'

    click_button "SAVE"

    wait_for_ajax

    expect(page).not_to have_errors if Capybara.javascript_driver == :webkit
  end

  it "allows correctly calculates item values quote items" do
    login
    visit "/quotes"

    find("#quotes-grid tbody tr:first-child").double_click
    wait_for_ajax

    expect(page).to have_content("Editing Quote")

    # Basic calculations
    within("#quote-items-grid tbody tr:first-child") do
      find(".stock-description-input:first-of-type").click
      find(".stock-description-input:first-of-type").set("New item description")
      find("td:nth-child(3) input").set(1)
      find("td:nth-child(4) input").set(10)

      expect(find("td:nth-child(9)")).to have_content("12.00")
    end

    within("#quote-items-grid tbody tr:first-child") do
      find(".stock-description-input:first-of-type").click
      find(".stock-description-input:first-of-type").set("New item description")
      find("td:nth-child(3) input").set(2)
      find("td:nth-child(4) input").set(75)

      expect(find("td:nth-child(9)")).to have_content(180.00)
    end

    click_button "SAVE"
    wait_for_ajax
  end

  it "allows you to delete a quote" do
    login
    visit "/quotes"

    find("#quotes-grid tbody tr:first-child").click

    find("#delete-quote-button").click
    find("#delete-quote-button").click

    wait_for_ajax

    expect(find("#quotes-grid tbody tr:first-child")).not_to have_content("Test notes")

    expect(page).not_to have_errors if Capybara.javascript_driver == :webkit
  end
end
