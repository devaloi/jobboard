require "test_helper"

module Admin
  class DashboardControllerTest < ActionDispatch::IntegrationTest
    test "admin can access dashboard" do
      sign_in users(:admin)
      get admin_dashboard_path
      assert_response :success
    end

    test "employer cannot access admin dashboard" do
      sign_in users(:employer_one)
      get admin_dashboard_path
      assert_redirected_to root_path
    end

    test "seeker cannot access admin dashboard" do
      sign_in users(:seeker_one)
      get admin_dashboard_path
      assert_redirected_to root_path
    end
  end
end
