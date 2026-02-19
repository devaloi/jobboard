require "test_helper"

module Seeker
  class DashboardControllerTest < ActionDispatch::IntegrationTest
    test "seeker can access dashboard" do
      sign_in users(:seeker_one)
      get seeker_dashboard_path
      assert_response :success
    end

    test "employer cannot access seeker dashboard" do
      sign_in users(:employer_one)
      get seeker_dashboard_path
      assert_redirected_to root_path
    end
  end
end
