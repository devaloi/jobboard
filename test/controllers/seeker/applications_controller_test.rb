require "test_helper"

module Seeker
  class ApplicationsControllerTest < ActionDispatch::IntegrationTest
    test "seeker can view their applications" do
      sign_in users(:seeker_one)
      get seeker_applications_path
      assert_response :success
    end

    test "employer cannot access seeker applications" do
      sign_in users(:employer_one)
      get seeker_applications_path
      assert_redirected_to root_path
    end
  end
end
