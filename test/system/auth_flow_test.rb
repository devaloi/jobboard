require "application_system_test_case"

class AuthFlowTest < ApplicationSystemTestCase
  test "user can sign up as a seeker and sign in" do
    visit new_user_registration_path

    select "Job Seeker", from: "Role"
    fill_in "Full name", with: "Test Seeker"
    fill_in "Email", with: "newseeker@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    click_on "Sign up"

    assert_text "Welcome"
  end

  test "employer can sign up with company name" do
    visit new_user_registration_path

    select "Employer", from: "Role"
    fill_in "Full name", with: "Test Employer"
    fill_in "Company name", with: "Test Corp"
    fill_in "Email", with: "newemployer@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    click_on "Sign up"

    assert_text "Welcome"
  end

  test "existing user can log in" do
    user = users(:seeker_one)

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_on "Log in"

    assert_text user.full_name
  end
end
