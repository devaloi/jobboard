require "test_helper"

module Admin
  class JobsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in users(:admin)
    end

    test "index shows all jobs" do
      get admin_jobs_path
      assert_response :success
    end

    test "destroy removes job" do
      assert_difference "Job.count", -1 do
        delete admin_job_path(jobs(:draft_job))
      end
      assert_redirected_to admin_jobs_path
    end

    test "non-admin cannot access" do
      sign_in users(:employer_one)
      get admin_jobs_path
      assert_redirected_to root_path
    end
  end
end
