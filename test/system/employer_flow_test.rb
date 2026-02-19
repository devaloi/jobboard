require "application_system_test_case"

class EmployerFlowTest < ApplicationSystemTestCase
  setup do
    @employer = users(:employer_one)
    visit new_user_session_path
    fill_in "Email", with: @employer.email
    fill_in "Password", with: "password123"
    click_on "Log in"
  end

  test "employer can create a new job listing" do
    visit new_employer_job_path

    fill_in "Title", with: "Full Stack Developer"
    fill_in "Location", with: "Remote"
    select "Engineering", from: "Category"
    select "Full time", from: "Job type"
    fill_in "Min Salary ($)", with: "80000"
    fill_in "Max Salary ($)", with: "120000"
    select "Published", from: "Status"
    click_on "Create Job"

    assert_text "Job listing created successfully"
  end

  test "employer can view their listings" do
    visit employer_jobs_path
    assert_text "My Job Listings"
    assert_text jobs(:published_rails_job).title
  end

  test "employer can access dashboard" do
    visit employer_dashboard_path
    assert_text "Employer Dashboard"
    assert_text "Total Listings"
  end
end
