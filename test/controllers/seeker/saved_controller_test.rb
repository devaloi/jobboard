require "test_helper"

module Seeker
  class SavedControllerTest < ActionDispatch::IntegrationTest
    test "seeker can view saved jobs" do
      sign_in users(:seeker_one)
      get seeker_saved_index_path
      assert_response :success
    end

    test "employer cannot access saved jobs" do
      sign_in users(:employer_one)
      get seeker_saved_index_path
      assert_redirected_to root_path
    end
  end
end
