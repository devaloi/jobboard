require "test_helper"

module Employer
  class ApplicationsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in users(:employer_one)
    end

    test "index shows applications for employer's job" do
      get employer_job_applications_path(jobs(:published_rails_job))
      assert_response :success
    end

    test "status update changes application status" do
      application = job_applications(:applied_application)
      patch status_employer_application_path(application), params: { status: "reviewed" }
      assert_redirected_to employer_job_applications_path(application.job)
      assert_equal "reviewed", application.reload.status
    end

    test "seeker cannot access employer applications" do
      sign_in users(:seeker_one)
      get employer_job_applications_path(jobs(:published_rails_job))
      assert_redirected_to root_path
    end
  end
end
