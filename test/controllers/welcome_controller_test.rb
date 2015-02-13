require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get index" do
    login

    get :index
    assert_response :success
  end
end
