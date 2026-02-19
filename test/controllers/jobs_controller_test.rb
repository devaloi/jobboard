require "test_helper"

class JobsControllerTest < ActionDispatch::IntegrationTest
  test "index renders successfully" do
    get jobs_path
    assert_response :success
  end

  test "show renders published job" do
    get job_path(jobs(:published_rails_job))
    assert_response :success
  end

  test "apply requires authentication" do
    post apply_job_path(jobs(:published_rails_job))
    assert_response :redirect
  end

  test "seeker can apply to published job" do
    sign_in users(:seeker_two)
    assert_difference "JobApplication.count", 1 do
      post apply_job_path(jobs(:published_rails_job)), params: { cover_letter: "I'm interested" }
    end
  end

  test "employer cannot apply to job" do
    sign_in users(:employer_one)
    post apply_job_path(jobs(:published_rails_job))
    assert_redirected_to job_path(jobs(:published_rails_job))
    assert_equal "Only job seekers can apply.", flash[:alert]
  end

  test "duplicate application is prevented" do
    sign_in users(:seeker_one)
    assert_no_difference "JobApplication.count" do
      post apply_job_path(jobs(:published_rails_job)), params: { cover_letter: "Again" }
    end
  end

  test "save job requires authentication" do
    post save_job_job_path(jobs(:published_rails_job))
    assert_response :redirect
  end

  test "seeker can save a job" do
    sign_in users(:seeker_two)
    assert_difference "SavedJob.count", 1 do
      post save_job_job_path(jobs(:published_rails_job))
    end
  end

  test "seeker can unsave a job" do
    sign_in users(:seeker_one)
    assert_difference "SavedJob.count", -1 do
      delete unsave_job_job_path(jobs(:published_design_job))
    end
  end

  test "index with search params" do
    get jobs_path, params: { q: { title_or_location_or_user_company_name_cont: "Rails" } }
    assert_response :success
  end

  test "index with category filter" do
    get jobs_path, params: { category: "engineering" }
    assert_response :success
  end

  test "index with job_type filter" do
    get jobs_path, params: { job_type: "full_time" }
    assert_response :success
  end

  test "index with sort parameter" do
    get jobs_path, params: { sort: "salary_high" }
    assert_response :success
  end
end
