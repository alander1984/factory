require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "should get newUser" do
    get :newUser
    assert_response :success
  end

end
