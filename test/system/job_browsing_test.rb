require "application_system_test_case"

class JobBrowsingTest < ApplicationSystemTestCase
  test "visitor can browse published jobs" do
    visit jobs_path
    assert_text "Job Listings"
    assert_text jobs(:published_rails_job).title
  end

  test "visitor can view job details" do
    job = jobs(:published_rails_job)
    visit job_path(job)
    assert_text job.title
    assert_text job.location
  end

  test "visitor can search for jobs" do
    visit jobs_path
    fill_in "q_title_or_location_or_user_company_name_cont", with: "Rails"
    click_on "Filter"
    assert_text "Senior Rails Developer"
  end
end
