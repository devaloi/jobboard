require "test_helper"

module Employer
  class JobsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in users(:employer_one)
    end

    test "index shows employer's jobs" do
      get employer_jobs_path
      assert_response :success
    end

    test "new renders form" do
      get new_employer_job_path
      assert_response :success
    end

    test "create with valid params" do
      assert_difference "Job.count", 1 do
        post employer_jobs_path, params: {
          job: {
            title: "New Job", location: "NYC", salary_min: 50000, salary_max: 100000,
            job_type: "full_time", status: "draft", category_id: categories(:engineering).id
          }
        }
      end
      assert_redirected_to employer_jobs_path
    end

    test "create with invalid params renders new" do
      assert_no_difference "Job.count" do
        post employer_jobs_path, params: {
          job: { title: "", location: "", category_id: categories(:engineering).id }
        }
      end
      assert_response :unprocessable_entity
    end

    test "edit renders form" do
      get edit_employer_job_path(jobs(:published_rails_job))
      assert_response :success
    end

    test "update with valid params" do
      patch employer_job_path(jobs(:published_rails_job)), params: {
        job: { title: "Updated Title" }
      }
      assert_redirected_to employer_jobs_path
      assert_equal "Updated Title", jobs(:published_rails_job).reload.title
    end

    test "destroy archives the job" do
      delete employer_job_path(jobs(:published_rails_job))
      assert_redirected_to employer_jobs_path
      assert jobs(:published_rails_job).reload.archived?
    end

    test "seeker cannot access employer jobs" do
      sign_in users(:seeker_one)
      get employer_jobs_path
      assert_redirected_to root_path
    end

    test "employer cannot access other employer's job for editing" do
      sign_in users(:employer_two)
      get edit_employer_job_path(jobs(:published_rails_job))
      assert_response :not_found
    end
  end
end
