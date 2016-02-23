require 'test_helper'

class SpravControllerTest < ActionController::TestCase
  test "should get chooseOrg" do
    get :chooseOrg
    assert_response :success
  end

end
