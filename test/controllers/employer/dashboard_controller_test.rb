require "test_helper"

module Employer
  class DashboardControllerTest < ActionDispatch::IntegrationTest
    test "employer can access dashboard" do
      sign_in users(:employer_one)
      get employer_dashboard_path
      assert_response :success
    end

    test "seeker cannot access employer dashboard" do
      sign_in users(:seeker_one)
      get employer_dashboard_path
      assert_redirected_to root_path
    end

    test "unauthenticated user is redirected" do
      get employer_dashboard_path
      assert_response :redirect
    end
  end
end
