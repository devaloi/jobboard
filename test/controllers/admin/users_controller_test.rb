require "test_helper"

module Admin
  class UsersControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in users(:admin)
    end

    test "index shows all users" do
      get admin_users_path
      assert_response :success
    end

    test "non-admin cannot access" do
      sign_in users(:seeker_one)
      get admin_users_path
      assert_redirected_to root_path
    end
  end
end
