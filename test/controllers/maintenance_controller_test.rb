require 'test_helper'

class MaintenanceControllerTest < ActionController::TestCase
  test "should get index" do
    login

    get :index
    assert_response :success
  end
end
